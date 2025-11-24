function addTask(){
  const taskInput = document.getElementByld('taskInput');
  const taslTest = taskInput.value.trim();
  if (taskText === '') {
      alert("Введите текст для задачи!");
      return;
}
const taskList=document.getElementById('taskList');
const li=document.createElement('li');
li.innerHTML = `
<span>${taskText}</span>
<button onclick="this.parentElement.remove()">Удалить</button>
`;
taskList.appendChild(li);
// Очищаем поле ввода и возвращаем фокус
taskInput.value='';
taskInput.focus();
