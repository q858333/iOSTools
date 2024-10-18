//
//  DBOpenGLVC.m
//  Tools
//
//  Created by dengbin on 2023/3/21.
//

#import "DBOpenGLVC.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
@interface DBOpenGLVC ()
{
    EAGLContext *context;
    GLKBaseEffect *myEffect;
}
@end

@implementation DBOpenGLVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    GLKView *glView = (GLKView *)self.view;
    glView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:glView.context];

    glEnable(GL_DEPTH_TEST); //开启深度测试，就是让离你近的物体可以遮挡离你远的物体。
    glClearColor(1, 0, 0, 1.0);
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
      if (context == nil) {
          NSLog(@"Failed to load context");
      }
      
    [EAGLContext setCurrentContext:context];
      //开启深度测试，就是让离你近的物体可以遮挡离你远的物体。
    glEnable(GL_DEPTH_TEST);
      
      //给glkView上下文赋值
    glView.context = context;
    [self setupVertexData];
    
    myEffect = [[GLKBaseEffect alloc] init];
    
    [self setupTexture];
 

}

- (void)setupTexture {
//    [GLKTextureInfo]
    NSString *path = [[NSBundle mainBundle] pathForResource:@"邓斌" ofType:@"JPG"] ;
    GLKTextureInfo *loader=  [GLKTextureLoader textureWithContentsOfFile:path options:@{
        GLKTextureLoaderOriginBottomLeft:@1
    } error:nil];
    myEffect.texture2d0.enabled = GL_TRUE;
    myEffect.texture2d0.name = loader.name;

}

- (void)setupVertexData {
//    GLfloat rectangleVertices[] = {
//        //位置：（x, y, z）颜色：（r, g, b）
//        0.5, -0.5, 0.0,    1.0, 0.0, 0.0,    1.0, 0.0, //右下
//           0.5, 0.5, 0.0,     1.0, 0.0, 0.0,    1.0, 1.0, //右上
//           -0.5, 0.5, 0.0,    1.0, 0.0, 0.0,    0.0, 1.0, //左上
//
//           0.5, -0.5, 0.0,    0.0, 1.0, 0.0,    1.0, 0.0, //右下
//           -0.5, 0.5, 0.0,    0.0, 1.0, 0.0,    0.0, 1.0, //左上
//           -0.5, -0.5, 0.0,   0.0, 1.0, 0.0,    0.0, 0.0  //左下
//
//    };
    
        GLfloat rectangleVertices[] = {
            -0.4, -0.4, 0.0,//座上
            -0.4, -0.8, 0.0,//左下
             0.4, -0.8, 0.0,//右下
             0.4, -0.4, 0.0,//忧伤
    
        };
    
    GLuint buffer ;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(rectangleVertices), rectangleVertices, GL_STATIC_DRAW);


    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE,3 * sizeof(float), (void *)0 );
    
//    glEnableVertexAttribArray(GLKVertexAttribColor);
//    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE,6 * sizeof(float),(void *)3 );
//
//    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
//    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT,GL_FALSE, 8 * sizeof(float), (void *)6);


}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    glClearColor(0, 0, 1.0, 1.0);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnableVertexAttribArray(0);

    
    [myEffect prepareToDraw];

    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}


@end
