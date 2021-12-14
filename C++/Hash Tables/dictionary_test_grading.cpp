#include "Dictionary.h"
#include <iostream>
using namespace std;

// Driver program

void small_dict_test()
{

    /* Small dictionary test as given in the provided test module. */
    cout << "!!!Small dictionary test starts!!!" << endl;

    // Initialize the dictionary.
    Dictionary small_dict;

    // BulkInsert the keys into the dictionary.
    /* Expected results: hash functions used, sum of squares of number of keys, number of trials, 3pts, 1pt each*/
    string strs[] = {"Fred Astaire", "Lauren Bacall", "Brigitte Bardot", "John Belushi", "Ingmar Bergman"};
    int n = 5;
    small_dict.bulkInsert(n, strs);


    // Insert "Humphrey Bogart" into the dictionary.
    /* Expected results: whether collisions happened in second level, 1pt*/
    small_dict.insert("Humphrey Bogart");

    // Remove "Lauren Bacall" from the dictionary.
    /* Expected results: removal is successful, 1pt*/
    small_dict.remove("Lauren Bacall");

    // Find "Fred Astaire" in the dictionary.
    /* Expected results: print 1, finding is successful, buckets accessed during the process, 1pt*/
    cout << small_dict.find("Fred Astaire") << endl;

    // Find "Lauren Bacall" in the dictionary.
    /* Expected results: print 0, finding is unsuccessful, item doesn't exist, 1pt*/
    cout << small_dict.find("Lauren Bacall") << endl;
}

void large_dict_test()
{

    /* Large dictionary test. */
    cout << "!!!Large dictionary test starts!!!" << endl;

    // Initialize the dictionary.
    Dictionary large_dict;

    // BulkInsert the keys into the dictionary.
    /* Expected results: hash functions used, sum of squares of number of keys, number of trials, 3pts, 1pt each*/
    string strs[] = {"Emma Ember", "Olivia Rosalie", "Ava Journee", "Isabella Presley", "Sophia Amy",
                     "Mia Mckenzie", "Amelia Alaina", "Harper Brooke", "Evelyn Alana",
                     "Abigail Summer", "Emily Rachel", "Elizabeth Mya", "Mila Everleigh", "Ella Daniela",
                     "Avery Jocelyn", "Sofia Amara", "Camila Josie", "Aria Gracie", "Scarlett Callie", "Victoria Ayla",
                     "Madison Londyn", "Luna Elliana", "Grace Sienna", "Chloe Juliette", "Penelope Diana",
                     "Layla Lucia", "Riley Laila", "Zoey Sloane", "Nora London", "Lily Alexis", "Eleanor Teagan",
                     "Hannah Remi", "Lillian Elise", "Addison Harmony", "Aubrey Arabella", "Ellie Sara",
                     "Stella Genevieve", "Natalie Lauren", "Zoe Kimberly", "Leah ", "Hazel Daisy", "Violet Trinity",
                     "Aurora Eloise", "Savannah Jordyn", "Brooklyn Morgan", "Bella Finley",
                     "Claire Parker", "Skylar Lilly", "Lucy Aliyah", "Paisley Reese", "Everly Molly", "Anna Alina",
                     "Caroline Valerie", "Nova Cecilia", "Genesis Ariel", "Emilia Esther", "Kennedy Charlie",
                     "Samantha Juliana", "Maya Alyssa", "Willow Kayla", "Kinsley Anastasia", "Naomi Emersyn",
                     "Aaliyah Eden", "Elena Ryleigh", "Sarah Adalyn", "Ariana Emerson", "Allison Valeria",
                     "Gabriella Annabelle", "Alice Norah", "Madelyn Isabel", "Cora Iris", "Ruby Melody", "Eva Jasmine",
                     "Serenity Khloe", "Autumn Andrea", "Adeline Bailey", "Hailey Brianna", "Gianna Eliza",
                     "Valentina Amaya", "Isla Ashley", "Eliana Lyla", "Quinn Margaret", "Nevaeh Mary", "Ivy Alexandra",
                     "Sadie Kylie", "Piper Rose", "Lydia Faith", "Alexa Taylor", "Josephine Leilani", "Emery Arya",
                     "Julia Ximena", "Delilah Athena", "Arianna Maria", "Vivian Raelynn", "Kaylee Natalia",
                     "Sophie Isabelle", "Brielle Katherine", "Madeline Jade", "Peyton Aubree", "Rylee Liliana",
                     "Clara Adalynn", "Hadley Reagan", "Melanie Mackenzie", "Mackenzie Melanie", "Reagan Hadley",
                     "Adalynn Clara", "Liliana Rylee", "Aubree Peyton", "Jade Madeline", "Katherine Brielle",
                     "Isabelle Sophie", "Natalia Kaylee", "Raelynn Vivian", "Maria Arianna", "Athena Delilah",
                     "Ximena Julia", "Arya Emery", "Leilani Josephine", "Taylor Alexa", "Faith Lydia", "Rose Piper",
                     "Kylie Sadie", "Alexandra Ivy", "Mary Nevaeh", "Margaret Quinn", "Lyla Eliana", "Ashley Isla",
                     "Amaya Valentina", "Eliza Gianna", "Brianna Hailey", "Bailey Adeline", "Andrea Autumn",
                     "Khloe Serenity", "Jasmine Eva", "Melody Ruby", "Iris Cora", "Isabel Madelyn", "Norah Alice",
                     "Annabelle Gabriella", "Valeria Allison", "Emerson Ariana", "Adalyn Sarah", "Ryleigh Elena",
                     "Eden Aaliyah", "Emersyn Naomi", "Anastasia Kinsley", "Kayla Willow", "Alyssa Maya",
                     "Juliana Samantha", "Charlie Kennedy", "Esther Emilia", "Ariel Genesis", "Cecilia Nova",
                     "Valerie Caroline", "Alina Anna", "Molly Everly", "Reese Paisley", "Aliyah Lucy", "Lilly Skylar",
                     "Parker Claire", "Finley Bella", "Morgan Brooklyn", "Sydney Audrey", "Jordyn Savannah",
                     "Eloise Aurora", "Trinity Violet", "Daisy Hazel", " Leah", "Kimberly Zoe", "Lauren Natalie",
                     "Genevieve Stella", "Sara Ellie", "Arabella Aubrey", "Harmony Addison", "Elise Lillian",
                     "Remi Hannah", "Teagan Eleanor", "Alexis Lily", "London Nora", "Sloane Zoey", "Laila Riley",
                     "Lucia Layla", "Diana Penelope", "Juliette Chloe", "Sienna Grace", "Elliana Luna",
                     "Londyn Madison", "Callie Scarlett", "Gracie Aria", "Josie Camila", "Amara Sofia",
                     "Jocelyn Avery", "Daniela Ella", "Everleigh Mila", "Mya Elizabeth", "Rachel Emily",
                     "Summer Abigail", "Alana Evelyn", "Brooke Harper", "Alaina Amelia", "Mckenzie Mia",
                     "Catherine Charlotte", "Amy Sophia", "Presley Isabella", "Journee Ava", "Rosalie Olivia",
                     "Ember Emma"};
    int n = 207;
    large_dict.bulkInsert(n, strs);

    // Find "Lillian Elise" in the dictionary.
    /* Expected results: print 1, finding is successful, buckets accessed during the process, 1pt*/
    cout << large_dict.find("Lillian Elise") << endl;

    // Remove "Zexi Huang" from the dictionary.
    /* Expected results: removal is unsuccessful, item doesn't exist, 1pt*/
    large_dict.remove("Zexi Huang");

    // Insert "Sean Jaffe" into the dictionary.
    /* Expected results: whether collisions happened in second level, 1pt*/
    large_dict.insert("Sean Jaffe");

    // Find "Sean Jaffe" in the dictionary.
    /* Expected results: print 1, finding is successful, buckets accessed during the process, 1pt*/
    cout << large_dict.find("Sean Jaffe") << endl;

    // Remove "Brooklyn Morgan" from the dictionary.
    /* Expected results: removal is successful, 1pt*/
    large_dict.remove("Brooklyn Morgan");

    // Find "Lillian Elise" in the dictionary.
    /* Expected results: print 1, finding is successful, buckets accessed during the process, results should be the same as the first find, 1pt*/
    cout << large_dict.find("Lillian Elise") << endl;

    // Find "Brooklyn Morgan" from the dictionary.
    /* Expected results: print 0, finding is unsuccessful, 1pt*/
    cout << large_dict.find("Brooklyn Morgan") << endl;

    // Remove "Lillian Elise" from the dictionary.
    /* Expected results: removal is successful, 1pt*/
    large_dict.remove("Lillian Elise");

    // Insert "Lillian Elise" into the dictionary.
    /* Expected results: whether collisions happened in second level, 1pt*/
    large_dict.insert("Lillian Elise");

    // Find "Lillian Elise" in the dictionary.
    /* Expected results: print 1, finding is successful, buckets accessed during the process, results should be the same as the first find, 1pt*/
    cout << large_dict.find("Lillian Elise") << endl;
}

int main()
{
    small_dict_test();
    large_dict_test();

    return 0;
}
