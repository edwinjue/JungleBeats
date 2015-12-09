class Node
  attr_accessor :data, :next_node

  def initialize(data, next_up)
    @data = data
    @next_node = next_up
  end
end

class List_Beats
  include Enumerable
  attr_accessor :voice, :speed

  VALIDBEATS = %W{tee ah dee i deep ya bop boop yo la chow ni ma da na ding oom gai bah knee how bang oh uh ha yes}
  VALIDVOICES = %W{Alice Boing}
  DEFAULT_VOICE = 'Boing'
  DEFAULT_SPEED = 500

  def initialize(data)
    @voice = DEFAULT_VOICE
    @speed = DEFAULT_SPEED
    @head = nil
    append(data)
  end

  def each
    if !@head.nil?                     #if head is not nil we have a list and can interate. simply iterate and yield data from each node
      current = @head
      while current.next_node != nil    
         yield current.data
         current = current.next_node
      end
      yield current.data

    end
  end

  #takes a string and converts it into a list
  def string_to_list(str)
    first_node = last_node = current = nil

    words = str.to_s.split  #convert string to an array of words  
    words.each do |word|
      if validate(word)     #process only valid words
        if first_node.nil?
          last_node = first_node = current = Node.new(word.to_s.downcase,nil) #when list has only 1 item, the first and last node will be the same
        else
          last_node = current.next_node = Node.new(word.to_s.downcase,nil)    #keep track of the last node in new list when adding more items
          current = current.next_node                           #increment current position to point to new node in the list
        end  
      end
    end

    first_node.nil? ? nil : first_node   #return nil if no valid words were processed, otherwise, return first node of the newly created list
  end

  def append(add_end)  
    new_list = string_to_list(add_end)  #create a new list with the words in add_end    

    if @head.nil?                     #if head is nil, the new_list will be the linked list
      @head = new_list  
    else
      current = @head
      while current.next_node != nil    #go to the last Node in the list
         current = current.next_node
      end
      current.next_node = new_list      #append new list to the existing linked list
    end
  end

  def prepend(add_begining)
    new_list = string_to_list(add_begining) #create a new list with the words in add_begining    

    if @head.nil?                         #if head is nil, the new_list will be the linked list
      @head = new_list  
    else
      current = new_list                    #go to end of new list
      while current.next_node != nil
        current = current.next_node
      end

      current.next_node = @head             #attach the new list to the head of existing linked list
      
      @head = new_list                      #update the head of the existing linked list to point to first node of prepended list 
    end
  end

  def insert(index,add_words)
    if index >= count
      puts "Inserting \'#{add_words}\' to the end of list"
      append(add_words)
    elsif index <= 0
      puts "Inserting \'#{add_words}\' to the beginning of list"  
      prepend(add_words)
    else
      #insert between nodes (simply reconstruct list)
      ar = to_a
      ar.insert(index,add_words)
      clear_list
      append(ar.join(' '))
    end
  end

  def pop(numToPop)
    current = @head
    if numToPop > count  #return nil if trying to pop more nodes than are in list
      puts "Error: you are trying to call pop more times than nodes exist. 0 nodes popped."
      nil
    else
      numExisting = count - numToPop
      if numExisting == 0
        @head = nil
      else
        (numExisting-1).times do
          current = current.next_node
        end
        current.next_node = nil
      end
    end
  end

  def play
    str = all_to_str
    if str
      sayWithSpeedAndVoice = "say -r #{@speed} -v #{@voice} \"#{str}\""
#     puts sayWithSpeedAndVoice
      `#{sayWithSpeedAndVoice}`
      
#     sayCmd = "say \"#{str}\""
#     `#{sayCmd}`
    end
  end

  def reset_voice
    @voice = DEFAULT_VOICE
  end

  def reset_speed
    @speed = DEFAULT_SPEED
  end

  def validate(input)
    lowercase_input = input.to_s.downcase    
    VALIDBEATS.include?lowercase_input
  end

  def all_to_str
    str = entries.join(' ')
  end

  def all
    puts all_to_str
  end

  def find(input)
    lowercase_input = input.to_s.downcase
    include?lowercase_input #use enumerable method include? to determine whether input is in the list
  end
  
  def clear_list
    @head = nil
  end

end

#list = List_Beats.new("Mississippi")
list = List_Beats.new("Miss I upp all baNG iss yO iPp MA ma ads ha fewa HA")

list.append("cHOw kneE Mississippi Ma ma")
list.prepend("yES")
list.prepend("oh")
list.pop(1)
list.prepend("ching chow knee")
#list.play
sorted = list.sort_by do |word| 
  word.length  #use enumerable method sort_by to sort by word length
end
puts sorted.inspect
result = list.find("kee") ? "kee is in the list" : "kee isn't in the list" 
puts 'list.find("kee") = ' + result #should output "kee isn't"
result = list.find("knee") ? "knee is in the list" : "knee isn't in the list" 
puts 'list.find("knee") = ' + result #should output "knee is"
result = list.include?("kee") ? "kee is in the list" : "kee isn't in the list" 
puts 'include?("kee") = ' + result #should output "kee isn't"
result = list.include?("knee") ? "knee is in the list" : "knee isn't in the list" 
puts 'include?("knee") = ' + result #should output "knee is"
list.all
list.insert(0,"knee")
list.insert(1,"how")
list.insert(5,"na Mississippi ma")
list.all
puts list.count