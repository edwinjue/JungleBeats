class Node
  attr_accessor :data, :next_node

  def initialize(data, next_up)
    @data = data
    @next_node = next_up
  end
end

class List_Beats

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

  def count
    count = 0
    current = @head
    if @current.nil?
      0
    else
      while current.next_node != nil
        count += 1
        current = current.next_node
      end
      count +=1
      count
    end
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

  #returns the last node of the current linked list
  def tail
    current = @head
    if current.nil?
      nil
    else
      while current.next_node != nil
        current = current.next_node
      end
      current
    end
  end

  #returns the last node of a specified linked list
  def getEnd(list)
    if list.nil?
      nil
    else
      while list.next_node != nil
        list = list.next_node
      end
      list
    end
  end

  #returns the node at the given index for the current list
  def atIndex(index)
    current = @head
    (index).times do
      current = current.next_node
    end
    #puts "current.data at index #{index} is #{current.data}"
    current
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
      #generate a list from add_words
      new_list = string_to_list(add_words)
      
      #get node before index, call it indexNode
      indexNode = atIndex(index-1)  
      
      #get node at index, call it afterIndexNode
      afterIndexNode = atIndex(index)

      #connect indexNode to the new list
      indexNode.next_node = new_list    

      #get the last node of the new list
      new_list_end = getEnd(new_list)

      #connect end of new list to afterIndexNode
      new_list_end.next_node = afterIndexNode
      
      puts "Inserting \'#{add_words}\' to index #{index}"  
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
    str = all
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

  def all
    str = ''
    # Travels through the list till you hit the "nil" at the end
    @current = @head
    if !@current.nil?
      while @current.next_node != nil
        str += @current.data.to_s + " "
        @current = @current.next_node
      end
      str += @current.data.to_s
    end
    str
  end
end

#list = List_Beats.new("Mississippi")
list = List_Beats.new("Miss I upp all baNG iss yO iPp MA ma ads ha fewa HA")

list.append("cHOw kneE Mississippi Ma ma")
list.prepend("yES")
list.prepend("oh")
list.pop(1)
list.prepend("ching chow knee")
list.play
puts list.all
list.insert(0,"knee")
puts list.all
list.insert(1,"how")
puts list.all
list.insert(5,"na Mississippi ma")
puts list.all
last_node = list.tail
puts "last_node.data = " + last_node.data
puts list.all
puts list.count