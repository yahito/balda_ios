import UIKit
import GLKit

class OpenGLView: GLKView, GLKViewDelegate {
    
    
    private var effect = GLKBaseEffect()
    private var time: Float = 0.0
    
    private let vertexData: [GLfloat] = [
        -1.0, -1.0, 0.0,   // bottom left
         1.0, -1.0, 0.0,   // bottom right
        -1.0,  1.0, 0.0,   // top left
         1.0,  1.0, 0.0    // top right
    ]
    
    private let vertexIndices: [GLubyte] = [
        0, 1, 2,
        2, 1, 3
    ]
    
    private var vertexBuffer: GLuint = 0
    private var indexBuffer: GLuint = 0
    
    private var shaderProgram: GLuint = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGL()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGL()
    }
    
    private func setupGL() {
        context = EAGLContext(api: .openGLES3)!
        EAGLContext.setCurrent(context)
        
        
        self.delegate = self
        
        setupBuffers()
        compileShaders()
    }
    
    private func setupBuffers() {
        glGenBuffers(1, &vertexBuffer)
      glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
      glBufferData(GLenum(GL_ARRAY_BUFFER), vertexData.count * MemoryLayout<GLfloat>.size, vertexData, GLenum(GL_STATIC_DRAW))
      
      glGenBuffers(1, &indexBuffer)
      glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
      glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), vertexIndices.count * MemoryLayout<GLubyte>.size, vertexIndices, GLenum(GL_STATIC_DRAW))
    }
    
    private func compileShaders() {
        let vertexShaderSource = """
        attribute vec4 position;
        varying vec2 vTexCoord;
        void main(void) {
            gl_Position = position;
            vTexCoord = position.xy * 0.5 + 0.5;
        }
        """
        
        let fragmentShaderSource = """
        precision mediump float;
        varying vec2 vTexCoord;
        uniform float uTime;
        void main(void) {
            float wave = sin(10.0 * vTexCoord.y + uTime);
            gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0) * (vTexCoord.y + 0.5 * wave);
        }
        """
        
        let vertexShader = compileShader(vertexShaderSource, with: GLenum(GL_VERTEX_SHADER))
        let fragmentShader = compileShader(fragmentShaderSource, with: GLenum(GL_FRAGMENT_SHADER))
        
        shaderProgram = glCreateProgram()
        glAttachShader(shaderProgram, vertexShader)
        glAttachShader(shaderProgram, fragmentShader)
        glLinkProgram(shaderProgram)
        
        glUseProgram(shaderProgram)
        
        let position = GLuint(glGetAttribLocation(shaderProgram, "position"))
        glEnableVertexAttribArray(position)
        glVertexAttribPointer(position, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, nil)
    }
    
    private func compileShader(_ source: String, with type: GLenum) -> GLuint {
        let shader = glCreateShader(type)
        var cSource = (source as NSString).utf8String
        glShaderSource(shader, 1, &cSource, nil)
        glCompileShader(shader)
        
        var compileStatus: GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &compileStatus)
        
        if compileStatus == GL_FALSE {
            var infoLength: GLsizei = 0
            glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &infoLength)
            let info = Array(repeating: GLchar(0), count: Int(infoLength))
            var actualLength: GLsizei = 0
            glGetShaderInfoLog(shader, GLsizei(info.count), &actualLength, UnsafeMutablePointer(mutating: info))
            let infoLog = String(cString: info)
            print("Shader compilation failed: \(infoLog)")
            exit(1)
        }
        
        return shader
    }
    
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        let uTime = glGetUniformLocation(shaderProgram, "uTime")
        glUniform1f(uTime, time)
        
        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(vertexIndices.count), GLenum(GL_UNSIGNED_BYTE), nil)
    }
}
