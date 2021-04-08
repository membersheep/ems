public static class ArrayRightRotation {  
  public static void rotateRight(int array[], int d, int n) {   
    for (int i = 0; i < d; i++)   
      rotateArrayByOne(array, n);      
  }
  
  public static void rotateArrayByOne(int array[], int n) {   
    if (n < 1 || array.length < 1) {
      return;
    }
    int i, temp;   
    temp = array[n - 1];   
    for (i = n-1; i > 0; i--)
      array[i] = array[i - 1];       
      array[0] = temp;   
  }
}
