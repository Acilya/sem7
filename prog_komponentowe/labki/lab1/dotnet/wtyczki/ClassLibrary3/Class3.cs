using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ClassLibrary3
{
    public class Class3
    {
        public static string s_getPluginName()
        {
            MessageBox.Show("Nazwa pluginu to: StringToLower");
            return "StringToLower";
        }

        public static void r_getPluginName(RichTextBox richBox)
        {
            richBox.Text = "StringToLower";
        }

        public static string s_StringToLower(string value)
        {
            string result = value.ToLower();
            MessageBox.Show("Tekst malymi literami: " + result);
            return "Tekst malymi literami: " + result;
        }

        public static void r_StringToLower(RichTextBox richBox)
        {
            string result = richBox.Text.ToLower();
            richBox.Text = "Tekst malymi literami: ";
            int length = "Tekst malymi literami: ".Length;
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }

        public static void e_StringToLower(RichTextBox richBox)
        {
            string result = richBox.SelectedText.ToLower();
            richBox.Text = "Tekst malymi literami: ";
            int length = "Tekst malymi literami: ".Length;
            richBox.SelectionStart = length;
            richBox.SelectionLength = 0;
            richBox.SelectionFont = new Font(richBox.Font, FontStyle.Bold);
            richBox.AppendText(result);
        }
    }
}
