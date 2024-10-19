---@diagnostic disable: missing-return
---返回软件本身的绝对路径
---@return string
function Cpp.CurrentPath()end

---返回某一绝对路径下的所有文件夹和文件
---@param path string
---@return table
function Cpp.GetDirectoryPath(path)end

---返回某一绝对路径下的所有文件夹和文件以及其子文件夹和子文件
---@param path string
---@return table
function Cpp.GetDirectoryPathAll(path)end

---返回路径下的文件名
---@param path string
---@return string
function Cpp.PathGetFileName(path)end

---返回绝对路径下是否存在文件或文件夹
---@param path string
---@return boolean
function Cpp.PathExists(path)end

---创建一个路径，返回的是 是否创建成功
---@param path string
---@return boolean
function Cpp.CreateDir(path)end

---可以通过解析系统变量，返回一个绝对路径
---@param path string
---@return string
function Cpp.GetAbsPath(path) end

---std::rename的封装，返回0是成功，理论上还可用于移动文件
---@param old_filename string
---@param new_filename string
---@return integer
function Cpp.Rename(old_filename, new_filename)end

---设置剪切板的新内容，返回的为 是否设置成功
---@param str string
---@return boolean
function Cpp.SetClipboard(str)end

---获得剪切板的内容，如果不存在之类的为一个""
---@return string
function Cpp.GetClipboard()end
