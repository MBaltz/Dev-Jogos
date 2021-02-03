class Camera {
  private float x;

  public float get_pos() {
    return this.x;
  }

  public Camera(float pos) {
    this.x = pos;
  }
  
  public void mover(float dx) {
    this.x -= dx;
  }
}
