using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ClassLibrary4
{
    public class Class4
    {
        public static string s_getPluginName()
        {
            MessageBox.Show("Nazwa pluginu to: SpacesToCamelcase");
            return "SpacesToCamelcase";
        }

        public static void r_getPluginName(RichTextBox richBox)
        {
            richBox.Text = "SpacesToCamelcase";
        }

        public static string s_SpacesToCamelcase(string value)
        {
            List<char> charArray = value.ToList();
            for (int i = 0; i < charArray.Count; i++)
            {
                if (charArray[i] == ' ' && i < charArray.Count - 1)
                {
                    charArray[i + 1] = char.ToUpper(charArray[i + 1]);
                    charArray.RemoveAt(i);
                }
            }
            string result = string.Join("", charArray);
            MessageBox.Show("Tekst bez spacji: " + result);
            return "Tekst bez spacji: " + result;
        }

        public static void r_SpacesToCamelcase(RichTextBox richBox)
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
            richBox.Text = "Tekst bez spacji: ";
            int length = "Tekst bez spacji: ".Length;
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }

        public static void e_SpacesToCamelcase(RichTextBox richBox)
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
            richBox.Text = "Tekst bez spacji: ";
            int length = "Tekst bez spacji: ".Length;
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }
    }
}
