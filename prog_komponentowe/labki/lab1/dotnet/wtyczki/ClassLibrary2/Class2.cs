using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ClassLibrary2
{
    public class Class2
    {
        public static string s_getPluginName()
        {
            MessageBox.Show("Nazwa pluginu to: StringToUpper");
            return "StringToUpper";
        }

        public static void r_getPluginName(RichTextBox richBox)
        {
            richBox.Text = "StringToUpper";
        }

        public static string s_StringToUpper(string value)
        {
            string result = value.ToUpper();
            MessageBox.Show("Tekst wielkimi literami: " + result);
            return "Tekst wielkimi literami: " + result;
        }

        public static void r_StringToUpper(RichTextBox richBox)
        {
            string result = richBox.Text.ToUpper();
            richBox.Text = "Tekst wielkimi literami: "; 
            int length = "Tekst wielkimi literami: ".Length;
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }

        public static void e_StringToUpper(RichTextBox richBox)
        {
            string result = richBox.SelectedText.ToUpper();
            richBox.Text = "Tekst wielkimi literami: ";
            int length = "Tekst wielkimi literami: ".Length;
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }
    }
}
