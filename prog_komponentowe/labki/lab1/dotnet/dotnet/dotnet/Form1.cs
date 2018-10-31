using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using System.Reflection;

namespace dotnet
{
    public partial class Form1 : Form
    {
        private string name;

        public Form1()
        {
            InitializeComponent();
            LoadPlugins();
        }

        void LoadPlugins()
        {
            /*for(int i = 0; i < 10; i++)
            {
                string description = "Opis" + i.ToString();
                string name = "Nazwa" + i.ToString();
                wtyczkiToolStripMenuItem.DropDownItems.Add(new ToolStripMenuItem(description, null, null, name));
            }*/
            List<String> plugins = new List<string>();
            foreach (string myFilename in Directory.GetFiles(@"D:\dotnet\wtyczki", "*.dll", SearchOption.AllDirectories))
            {
                Assembly plugin = Assembly.LoadFrom(myFilename);
                foreach (Type item in plugin.GetTypes())
                {
                    //Console.WriteLine(item.Name);
                    foreach (MethodInfo method in item.GetMethods())
                    {
                        if(method.DeclaringType.Name == item.Name && !plugins.Contains(item.Name + '.' + method.Name)) //&& !wtyczkiToolStripMenuItem.DropDownItems.ContainsKey(myFilename + "|" + item.Name + "|" + method.Name))
                        {
                            wtyczkiToolStripMenuItem.DropDownItems.Add(
                                new ToolStripMenuItem(item.Name + '.' + method.Name.Substring(2), null, MenuHandler, myFilename + "|" + item.Name + "|" + method.Name));
                            plugins.Add(item.Name + '.' + method.Name);
                        }
                    }
                }
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            SaveFileDialog saveFile1 = new SaveFileDialog();
            saveFile1.DefaultExt = "*.rtf";
            saveFile1.Filter = "RTF Files|*.rtf";

            if (saveFile1.ShowDialog() == System.Windows.Forms.DialogResult.OK && saveFile1.FileName.Length > 0)
            {
                richTextBox1.SaveFile(saveFile1.FileName);
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFile1 = new OpenFileDialog();
            openFile1.DefaultExt = "*.rtf";
            openFile1.Filter = "RTF Files|*.rtf";

            if (openFile1.ShowDialog() == System.Windows.Forms.DialogResult.OK && openFile1.FileName.Length > 0)
            {
                richTextBox1.LoadFile(openFile1.FileName);
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void menuStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            name = textBox1.Text;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if(!wtyczkiToolStripMenuItem.DropDownItems.ContainsKey(name))
            {
                wtyczkiToolStripMenuItem.DropDownItems.Add(new ToolStripMenuItem("Menu item", null, MenuHandler, name));
            }
        }

        private void MenuHandler(object sender, EventArgs e)
        {
            ToolStripMenuItem item = (ToolStripMenuItem)sender;
            string[] names = item.Name.Split(new char[] { '|' });
            string NazwaAssembly = names[0];
            string NazwaKlasy = Path.GetFileNameWithoutExtension(NazwaAssembly) + "." + names[1];
            string NazwaMetody = names[2];
            //MessageBox.Show("Wcisnieto menu.\nKlucz: " + item.Name + " Napis: " + item.Text);
            //MessageBox.Show("Wcisnieto menu.\nKlucz: " + item.Name + " Po rozbiciu: " + NazwaAssembly + "." + NazwaKlasy + "." + NazwaMetody); ;
            Assembly plugin = Assembly.LoadFrom(NazwaAssembly);
            Type item2 = plugin.GetType(NazwaKlasy);
            MethodInfo method = item2.GetMethod(NazwaMetody);
            if (method != null)
            {
                if (method.Name.Substring(0,1) == "s")
                {
                    object result = method.Invoke(null, new object[] { richTextBox1.Text });
                }   
                else if (method.Name.Substring(0,1) == "r" || method.Name.Substring(0, 1) == "e")
                {
                    object result = method.Invoke(null, new object[] { richTextBox1 });
                }
            }
            else
            {
                MessageBox.Show("Blad wywolania funkcji!");
            }
        }
    }
}
