//Nick Kitchel
//CS 210
//Java Assignment

//imported libraries for functions
import java.util.Scanner;
import java.io.*;
import java.io.File;
import java.io.IOException;

//main program function
public class Javaprogram
{
	public static void main(String[] args)
	{
		try
		{	//create a new file if one doesn't exist
			File myObj = new File("uniuml.json");
				//print if the file was created or failed
			if (myObj.createNewFile())
			{
				println("File created: " + myObj.getName());
			} 
			else
			{
				System.out.println("File already exists!");
			}
		}	//catch errors if the program freaks
		catch (IOException e)
		{
			System.out.println("An error occurred");
		}
		int args_count = args.length;
		int count_files = 0;

		try
		{		//attempts to create a writer to the file
			FileWriter myWriter = new FileWriter("uniuml.json");
				//loop to travel through all .icn files
			while(count_files < args_count)
			{
				int word_count = 0, j = 0, i = 0, already_done = 0,super_class = 0, seen_super_already = 0;
				int not_over_class = 0,seen_method = 0, depth_count = 0, double_end = 0;
				String line = null, class_search= "class", method_search = "method";
				String[] words = null;
				String curr_class_mark = "0";
					//creates file reader of .icn file
				FileReader fileReader = new FileReader(args[count_files]);

				BufferedReader bufferedReader = new BufferedReader(fileReader);
					//traverses through file one line at a time
				while((line = bufferedReader.readLine()) != null)
				{		
					super_class = 0;
					already_done = 0;
					seen_super_already = 0;
					int quit_loop = 0;
						//check if the line has at least one word
					if(line.length() > 0)
					{		//get rid of spaces at beginning of lines
						Character space = new Character(' ');
						Character tab = new Character('\t');
						Character first_char = new Character(line.charAt(0));

						while((((space.equals(first_char)) || (tab.equals(first_char))) && (quit_loop == 0)))
						{		//change the line to remove the spaces
							if(line.length() > 1)
							{
								line = line.substring(1, line.length());
								first_char = new Character(line.charAt(0));
							} else
							{
								quit_loop = 1;
							}
						}
					}
						//splits the currnet line by spaces
					words = line.split(" ");
						//traverses through the line one word at a time
					for(String word : words)
					{		//check if the current word is and end of something
						if(words[0].equals("end"))
						{		//checks if we are already into a class
							if(depth_count >= 1)
							{		//if we are, then take one away from depth count
								depth_count--;
							}
								//if depth is zero then we are at the end of a class
							if(depth_count == 0)
							{
								super_class = 0;
								seen_method = 0;
									//tells us if we are at already past the first class
								if(curr_class_mark.equals("1"))
								{		//check if we are at the end of a method and a class
									if(double_end == 1)
									{		//print an ending character '}'
										myWriter.write("\n}");
									}	
										//end the class with a new line after it
									myWriter.write("\n}\n\n");
								}
							}
						}
						
						for(i = 0; i < words.length; i++)
						{
							if(words[i].equals(":"))
							{
								super_class = 1;
							}
						}

						if((super_class == 1) && (seen_super_already == 0))
						{
							depth_count++;

							seen_super_already = 1;
							myWriter.write("{ \"class\": \"" + words[1] + "\",\n");
							
							int start_index = first_paren(words[3]);

							if(start_index == 0)
							{
								myWriter.write("  \"super\": [\"" + words[3] + "\"");
							} else
							{
								myWriter.write("  \"super\": [\"" + words[3].substring(0, start_index) + "\"");
							}
							
							for(i = 6; i < words.length; i += 2)
							{
								int start_paren = first_paren(words[i - 1]);

								if(start_paren == 0)
								{
									myWriter.write(", \"" + words[i - 1] + "\"");
								} else
								{
									myWriter.write(", \"" + words[i - 1].substring(0, start_paren - 1) + "\"");
								}
							}
							
							myWriter.write("]\n}\n");
							
							//determines if we have found a class, and check to make sure its not on a comment or something
						} else if((words[0].equals(class_search) && (already_done == 0)) || (not_over_class == 1))
						{		//tells us we have already seen this line
							already_done = 1;
								//means we haven't found a class so we increase depth to say we now are
							if(not_over_class == 0)
							{		//increase the depth tracker if we are in a new class
								depth_count++;
							}
								//checks if we have already seen this class and marked it down
							if((words[0].equals(class_search)) && (not_over_class == 1))
							{
								//do nothing because we have already marked the current line
							}else if (not_over_class == 1)
							{	//if we are on a new line and at the end of a class
								int end_paren = last_paren(words[0]);
								
								myWriter.write("	\"" + word.substring(0, word.length() - 1) + "\",\n");
										//check if the last paren is on the same line
								if(end_paren != 0)
								{		//if it is then we will end the fields now
									myWriter.write("]\n");
									not_over_class = 0;
								}
								//if we just have a class with fields without a space
							}else if(2 == words.length)
							{
								int start_paren = first_paren(words[1]);
								int end_paren = last_paren(words[1]);

								int count = start_paren + 1;
								String[] classes = null;
								classes = words[1].split(",");
								int loop = classes.length;

								if((loop == 1) && (end_paren != 0))
								{
									start_paren = first_paren(classes[0]);
									end_paren = last_paren(classes[0]);
									
									if((start_paren + 1) != (end_paren - 1))
									{
										myWriter.write("{ \"class\": \"" + classes[0].substring(0, start_paren) + "\",\n");
										myWriter.write("\"fields\": [\"" + classes[0].substring(start_paren + 1, end_paren - 1) + "\"]\n");
									} else
									{
										myWriter.write("{ \"class\": \"" + classes[0].substring(0, start_paren) + "\",\n");
										myWriter.write("\"fields\": []\n");
									}
								} else if((loop == 1) && (end_paren == 0))
								{
									myWriter.write("{ \"class\": \"" + classes[0].substring(0, start_paren) + "\",\n");
									myWriter.write("\"fields\": [\"" + classes[0].substring(start_paren + 1, classes[0].length()) + "\"\n");
								
									not_over_class = 1;
								} else 
								{
									myWriter.write("{ \"class\": \"" + classes[0].substring(0, start_paren) + "\",\n");

									for(i = 0; i < loop; i++)
									{
										if(i == 0)
										{
											start_paren = first_paren(classes[i]);
									
											myWriter.write("\"fields\": [\"" + classes[i].substring(start_paren + 1, classes[i].length()) + "\"");
										} else 
										{
											end_paren = last_paren(classes[i]);
								
											myWriter.write(", \"" + classes[i].substring(0, end_paren - 1) + "\"");
										}
									}

									myWriter.write("]\n");
								}
								
							} else if(3 == words.length)
							{
								int start_paren = first_paren(words[2]);
								int end_paren = last_paren(words[2]);

								int count = start_paren + 1;
								String[] classes = null;
								classes = words[2].split(",");
								int loop = classes.length;

								if(first_paren(words[1]) != 0)
								{
									start_paren = first_paren(words[1]);
									
									myWriter.write("{ \"class\": \"" + words[1].substring(0, start_paren) + "\",\n");
									myWriter.write("\"fields\": [\"" + words[1].substring(start_paren + 1, words[1].length() - 1));
									
									if(loop == 1)
									{
										myWriter.write(",\n	\"" + words[2].substring(0, words[2].length() - 1));
									}
									
									myWriter.write("\"\n]\n");




								} else if((loop == 1) && (end_paren != 0))
								{
									start_paren = first_paren(classes[0]);
									end_paren = last_paren(classes[0]);
									
									if((start_paren + 1) != (end_paren - 1))
									{
										myWriter.write("{ \"class\": \"" + classes[0] + "\",\n");
										myWriter.write("\"fields\": [\"" + classes[0].substring(start_paren + 1, end_paren - 1) + "\"]\n");
									} else
									{
										myWriter.write("{ \"class\": \"" + classes[0] + "\",\n");
										myWriter.write("\"fields\": []");
									}
								} else if((loop == 1) && (end_paren == 0))
								{
									myWriter.write("{ \"class\": \"" + words[1] + "\",\n");
									myWriter.write("\"fields\": [\"" + classes[0].substring(start_paren + 1, classes[0].length()) + "\"\n");
								
									not_over_class = 1;
								} else 
								{
									myWriter.write("{ \"class\": \"" + words[1] + "\",\n");

									for(i = 0; i < loop; i++)
									{
										if(i == 0)
										{
											start_paren = first_paren(classes[i]);
									
											myWriter.write("\"fields\": [\"" + classes[i].substring(start_paren + 1, classes[i].length()) + "\"");
										} else 
										{
											end_paren = last_paren(classes[i]);
								
											myWriter.write(", \"" + classes[i].substring(0, end_paren - 1) + "\"");
										}
									}

									myWriter.write("]\n");
								}
							} else
							{
								//do nothing
							}

							curr_class_mark = "1";		
						}

						//check for method and see if its the first call in this class
						if((word.equals(method_search)) && (curr_class_mark.equals("1")) && (words.length < 4))
						{
							double_end = 1;
							depth_count++;

							int start_paren = first_paren(words[1]);
							int end_paren = last_paren(words[1]);
							
							if(seen_method == 1)
							{
								myWriter.write("\n\"" + words[1].substring(0, start_paren) + "\": [");
							} else
							{
								myWriter.write("\"methods\": {\n\"" + words[1].substring(0, start_paren) + "\": [");
							}
							
							if(2 == words.length)
							{
								int count = start_paren + 1;
								String[] methods = null;
								methods = words[1].split(",");
								int loop = methods.length;
									
								if(loop == 1)
								{
									start_paren = first_paren(methods[0]);
									end_paren = old_last_paren(methods[0]);
									
									if((start_paren + 1) != end_paren)
									{
										myWriter.write("\"" + methods[0].substring(start_paren + 1, end_paren) + "\"");
									}

								} else
								{
								
									for(i = 0; i < loop; i++)
									{
										if(i == 0)
										{
											start_paren = first_paren(methods[i]);
										
											myWriter.write("\"" + methods[i].substring(start_paren + 1, methods[i].length()) + "\"");
										} else 
										{
											end_paren = old_last_paren(methods[i]);
									
											myWriter.write(", \"" + methods[i].substring(0, end_paren) + "\"");
										}
									}
								}
							
								myWriter.write("]");

								seen_method = 1;
							}else
							{
								int count = start_paren + 1;
								String[] methods = null;
								methods = words[1].split(",");
								int loop = words.length;

								if(loop < 3)
								{
									start_paren = first_paren(words[1]);

									myWriter.write("\"" + methods[0].substring(start_paren + 1, methods[0].length() - 1) + "\"");
								} else
								{
									for(i = 1; i < words.length; i++)
									{
										start_paren = first_paren(words[i]);
										end_paren = last_paren(words[i]);
										
										if(end_paren != 0)
										{
											myWriter.write("\"" + words[i].substring(start_paren, words[i].length() - 1) + "\"");
										} else if(start_paren == 0)
										{
											myWriter.write(", \"" + words[i] + "\"");
										} else
										{
											myWriter.write("\"" + words[i].substring(start_paren + 1, words[i].length() - 1) + "\", ");
										}
									}
								}

								myWriter.write("]");
								seen_method = 1;
							} 
						}
					}
				}

				count_files++;
				bufferedReader.close();
			}
				
			myWriter.close();
			
		}
		catch(IOException ex)
		{
			println("Error reading file named '" + args[count_files] + "'");
		}

		println("End of program!");
	}
		//method to find the first parenthesis
	private static int first_paren(String line)
	{	
		int i = 0;	//count for position
		int result = 0; //location of parenthesis
		Character paren = new Character('(');	//set char to end goal
		Character current = new Character(line.charAt(i));	//set current position in string

		//loop through string looking for parenthesis
		while((i + 1) < line.length())
		{		//check if we ever find the starting parenthesis
			if(paren.equals(current))
			{
				result = i;
			}
				
			i++;
				//set the new character to the next one on the line
			current = new Character(line.charAt(i));
		}
			//return the number where the parenthesis is or return zero if it doesn't find it
		return result;
	}
		//method looking for last parenthesis
	private static int last_paren(String line)
	{		//find the length of the line
		int result = line.length();
			//set the character to look for
		Character paren = new Character(')');	//set char to end goal
		Character current = new Character(line.charAt(result - 1));	//set current position in string
			//see if the last character is the paren we are looking for
		if(paren.equals(current))
		{		//return the position
			return result;
		} else
		{		//otherwise return zero to show we didn't find it
			return 0;
		}
	}
		//old function used in method searching
	private static int old_last_paren(String line)
	{
		int result = line.length() - 1;

		return result;
	}
		//method so typing print is shorter
	private static void print(String x)
	{
        System.out.print(x);
    }
		//method so typing println is shorter
	private static void println(String x)
	{
        System.out.println(x);
    }
}