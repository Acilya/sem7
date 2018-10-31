using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ClassLibrary1
{
    public class Class1
    {
        public static string s_getPluginName()
        {
            MessageBox.Show("Nazwa pluginu to: ReverseString");
            return "ReverseString";
        }

        public static void r_getPluginName(RichTextBox richBox)
        {
            richBox.Text = "ReverseString";
        }

        public static string s_ReverseString(string value)
        {
            char[] charArray = value.ToCharArray();
            Array.Reverse(charArray);
            string result = new string(charArray);
            MessageBox.Show("Odwrocony tekst to: " + result);
            return "Odwrocony tekst to: " + result;
        }

        public static void r_ReverseString(RichTextBox richBox)
        {
            char[] charArray = richBox.Text.ToCharArray();
            Array.Reverse(charArray);
            string result = new string(charArray);
            richBox.Text = "Odwrocony tekst to: "; //+ result;
            int length = "Odwrocony tekst to: ".Length;
            //richBox.Select(length, result.Length);
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }

        public static void e_ReverseString(RichTextBox richBox)
        {
            char[] charArray = richBox.SelectedText.ToCharArray();
            Array.Reverse(charArray);
            string result = new string(charArray);
            richBox.Text = "Odwrocony tekst to: "; //+ result;
            int length = "Odwrocony tekst to: ".Length;
            //richBox.Select(length, result.Length);
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }

        //registerPlugin
    }
}
