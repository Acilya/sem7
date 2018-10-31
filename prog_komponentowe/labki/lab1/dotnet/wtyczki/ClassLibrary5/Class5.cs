using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ClassLibrary5
{
    public class Class5
    {
        public static string s_getPluginName()
        {
            MessageBox.Show("Nazwa pluginu to: StringWithoutA");
            return "StringWithoutA";
        }

        public static void r_getPluginName(RichTextBox richBox)
        {
            richBox.Text = "StringWithoutA";
        }

        public static string s_StringWithoutA(string value)
        {
            List<char> charArray = value.ToList();
            for (int i = 0; i < charArray.Count; i++)
            {
                if (charArray[i] == 'A' || charArray[i] == 'a')
                {
                    charArray.RemoveAt(i);
                }
            }
            string result = string.Join("", charArray);
            MessageBox.Show("Tekst bez litery A: " + result);
            return "Tekst bez litery A: " + result;
        }

        public static void r_StringWithoutA(RichTextBox richBox)
        {
            List<char> charArray = richBox.Text.ToList();
            for (int i = 0; i < charArray.Count; i++)
            {
                if (charArray[i] == ' ' && i < charArray.Count - 1)
                {
                    charArray[i + 1] = char.ToUpper(charArray[i + 1]);
                    charArray.RemoveAt(i);
                }
            }
            string result = string.Join("", charArray);
            richBox.Text = "Tekst bez litery A: ";
            int length = "Tekst bez litery A: ".Length;
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }

        public static void e_StringWithoutA(RichTextBox richBox)
        {
            List<char> charArray = richBox.SelectedText.ToList();
            for (int i = 0; i < charArray.Count; i++)
            {
                if (charArray[i] == ' ' && i < charArray.Count - 1)
                {
                    charArray[i + 1] = char.ToUpper(charArray[i + 1]);
                    charArray.RemoveAt(i);
                }
            }
            string result = string.Join("", charArray);
            richBox.Text = "Tekst bez litery A: ";
            int length = "Tekst bez litery A: ".Length;
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }
    }
}
