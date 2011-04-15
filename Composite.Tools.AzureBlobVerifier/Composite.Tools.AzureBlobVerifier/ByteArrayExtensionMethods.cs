﻿namespace Composite.Tools.AzureBlobVerifier
{
    internal static class ByteArrayExtensionMethods
    {
        public static int ComputeHash(this byte[] data)
        {
            unchecked
            {
                const int p = 16777619;
                int hash = (int)2166136261;

                for (int i = 0; i < data.Length; i++)
                {
                    hash = (hash ^ data[i]) * p;
                }

                hash += hash << 13;
                hash ^= hash >> 7;
                hash += hash << 3;
                hash ^= hash >> 17;
                hash += hash << 5;
                return hash;
            }
        }
    }
}
