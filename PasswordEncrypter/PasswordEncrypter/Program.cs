using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ukplc.Websites.Authentication;

namespace PasswordEncrypter
{
    class Program
    {
        static void Main(string[] args)
        {
            string password = "HMRCDatapack1";

            PasswordPolicy p = new PasswordPolicy();

            string newPassword = PasswordPolicy.Encrypt(password, 1204385);
        }
    }
}
