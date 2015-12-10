class Node
  attr_accessor :data, :next_node

  def initialize(data = nil, next_up = nil)
    @data = data
    @next_node = next_up
  end
end

class List_Beats

  attr_reader :voice, :speed

  VALIDBEATS = %W{tee ah dee i deep ya bop boop yo la chow ni ma da na ding oom gai bah knee how bang oh uh ha chi yes}
  VALIDVOICES = %W{Alice Boing}
  DEFAULT_VOICE = 'Boing'
  DEFAULT_SPEED = 500

  def initialize(data)
    @head = nil
    @voice = DEFAULT_VOICE
    @speed = DEFAULT_SPEED
    append(data)
  end

  #custom setter methods for :voice and :speed used to perform validation
  
  #validate voice
  def voice=(new_voice)
    if VALIDVOICES.include?(new_voice)
      @voice = new_voice
    else
      raise ArgumentError, "voice: '#{new_voice}'' is not a valid voice. Try: " + VALIDVOICES.inspect
    end
  end

  #validate speed
  def speed=(new_speed)
    if new_speed <=0
      raise ArgumentError, "speed: '#{new_speed}' is not a valid speed. Try: a value greater than zero"
    else
      @speed = new_speed
    end
  end

  #each method used to enumerate linked list data
  def each
    #if head is not nil we have a list and can interate. 
    #simply iterate and yield data from each node
    if !@head.nil?                     
      current = @head
      while current.next_node != nil    
         yield current.data
         current = current.next_node
      end
      yield current.data

    end
  end

  #returns the number of nodes in the linked list
  def count
    count = 0
    each do |data|
      count += 1
    end
    count
  end

  #returns the last node of the linked list
  def tail
    current = @head
    (count - 1).times do
      current = current.next_node
    end
    current
  end

  #returns the last node of a specified list
  def getEnd(list)
    if list.nil?
    else
      while list.next_node != nil
        list = list.next_node
      end      
    end
    list
  end

  #returns the node at the given index for the linked list
  def atIndex(index)
    current = @head
    (index).times do
      current = current.next_node
    end
    #puts "current.data at index #{index} is #{current.data}"
    current
  end

  #returns true if the specified word is in the linked list
  def include?(word)
    if !@head.nil?
      each do |data|
        if data.to_s.downcase == word.downcase
          return true
        end    
      end
    end
    false
  end

  #alias for include?
  def find(word)
    include?word
  end

  #takes a string and converts it into a list
  def string_to_list(str)
    first_node = current = nil

    #convert input string to an array of words  
    words = str.to_s.split  
    
    #create a node for each word in the array
    words.each do |word|
      #process only valid words
      if validate(word)     
        if first_node.nil?
          #no list yet, create first_node
          first_node = current = Node.new(word.to_s.downcase.strip,nil) 
        else
          #add and connect a new node
          current.next_node = Node.new(word.to_s.downcase.strip,nil)    
          current = current.next_node                           
        end  
      end
    end

    #return first node of list or nil if no valid words
    first_node
  end

  def append(add_end)  
    #create a new list with the words in add_end    
    new_list = string_to_list(add_end)  

    if @head.nil?
      #if head is nil, the new_list will be the linked list
      @head = new_list  
    else
      #go to the last Node in the list
      current = tail

      #append new list to end of the linked list
      current.next_node = new_list
    end
  end

  def prepend(add_begining)
    new_list = string_to_list(add_begining) #create a new list with the words in add_begining    

    if @head.nil?                         
      #if head is nil, the new_list will be the linked list
      @head = new_list  
    else
      current = new_list                    
      
      #go to end of new list
      new_list_end = getEnd(new_list)

      #attach end of new list to the head of the linked list
      new_list_end.next_node = @head             
      
      #update the head to point to first node of new list 
      @head = new_list                      
    end
  end

  def insert(index,add_words)
    if index >= count
      #puts "Inserting \'#{add_words}\' to the end of list"
      append(add_words)
    elsif index <= 0
      #puts "Inserting \'#{add_words}\' to the beginning of list"  
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
      
      #puts "Inserting \'#{add_words}\' to index #{index}"  
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
    all
  end

  def play
    if count
      sayWithSpeedAndVoice = "say -r #{@speed} -v #{@voice} \"" + all + "\""
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
    each do |data|
      str += data.to_s + ' '
    end
    str.strip
  end

end
=begin
puts List_Beats::VALIDBEATS.inspect
#list = List_Beats.new("Invalid")
#puts list.inspect
list = List_Beats.new("Miss I upp all baNG iss yO iPp MA ma ads ha fewa HA")
puts list.all
list.append("cHOw kneE Mississippi Ma ma")
puts list.all
list.prepend("yES")
puts list.all
list.prepend("oh")
puts list.all
list.voice = "Alice"
list.pop(1)
list.prepend("ching chow knee")
#list.play
puts list.all
list.insert(0,"knee")
puts list.all
list.insert(1,"how")
#list.speed = -1
puts list.all
list.insert(5,"na Mississippi ma")
puts list.all
result = list.include?"chow"
puts "is chow included in the list? list.include?\"chow\" = " + result.to_s
result = list.include?"notInList"
puts "is notInList included in the list? list.include?\"notInList\" = " + result.to_s
result = list.find("chow")
puts "is chow found in the list? list.find(\"chow\") = " + result.to_s
result = list.find("notInList")
puts "is notInList found in the list? list.find(\"notInList\") = " + result.to_s
last_node = list.tail
puts "last_node.data = " + last_node.data
puts list.all
puts list.count
=end
