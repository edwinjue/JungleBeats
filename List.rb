class Node
  attr_accessor :data, :next_node

  def initialize(data, next_up)
    @data = data
    @next_node = next_up

  end
end

class List_Beats
  attr_accessor :voice, :speed

  def initialize(data)
    @count = 0
    @voice = 'Boing'
    @speed = 500
    words = data.to_s.split

    @validBeats = %W{tee ah dee i deep ya bop boop yo la chow ni ma da na ding oom gai bah knee bang oh uh ha yes}
    @head = nil
    for word in words
      append(word)    
    end
  end
  
  def count
    @count = 0
    current = @head
    if current.nil?
      0
    else
      while current.next_node != nil
        @count += 1
        current = current.next_node
      end 
      @count +=1
      puts @count
    end
  end

  #takes a string and converts it into a list
  def string_to_list(str)
    first_node = last_node = current = nil

    words = str.to_s.split  #convert string to an array of words  
    for word in words       
      if validate(word)     #process only valid words
        if first_node.nil?
          last_node = first_node = current = Node.new(word,nil) #when list has only 1 item, the first and last node will be the same
        else
          last_node = current.next_node = Node.new(word,nil)    #keep track of the last node in new list when adding more items
          current = current.next_node                           #increment current position to point to new node in the list
        end
        @count += 1
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

    self                                #return the linked list
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

    self  #return current list

  end

  def pop(numToPop)
    current = @head
    if numToPop > @count  #return nil if trying to pop more nodes than are in list
      puts "numToPop > @count"
      nil
    else
      numExisting = @count - numToPop
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
    speed = @speed
    voice = @voice

    if(str != '')
#      sayWithSpeedAndVoice = "say -r #{speed} -v #{voice} \"#{str}\""
#      `#{sayWithSpeedAndVoice}`
      sayCmd = "say \"#{str}\""
      `#{sayCmd}`
    end
  end

  def validate(input)
    lowercase_input = input.to_s.downcase
    @validBeats.include?lowercase_input
  end

  def all_to_str
    str = ''

    # Traverse through the list till you hit the "nil" at the end
    current = @head
    if current.nil?
      str
    else
      while current.next_node != nil
        str += current.data.to_s + " "    
        current = current.next_node
      end
      str += current.data.to_s    
    end
  end

  def all
    str = all_to_str
    puts str
  end
end

#list = List_Beats.new("Mississippi")
list = List_Beats.new("Miss I upp all baNG iss yO iPp MA ads ha fewa HA")

list.append("cHOw kneE Mississippi Ma")
list.prepend("yES")
list.prepend("oh")
list.pop(1)
#list.prepend("chow knee Mississippi ma")
list.play

list.all
list.count