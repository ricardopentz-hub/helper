import SwiftUI

struct TaskRowView: View {
    var task: TaskItem
    var toggleAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggleAction) {
                ZStack {
                    Circle()
                        .strokeBorder(task.isDone ? Color.appTeal : Color.secondary.opacity(0.5), lineWidth: 2)
                        .frame(width: 36, height: 36)

                    if task.isDone {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                            .padding(8)
                            .background(Circle().fill(Color.appTeal))
                    }
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.body)
                    .foregroundColor(task.isDone ? .secondary : .primary)
                    .strikethrough(task.isDone, color: .secondary)

                if task.isDone {
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Image(systemName: "ellipsis")
                .foregroundColor(.secondary)
                .opacity(0.6)
                .padding(.leading, 6)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.03), lineWidth: 1)
        )
        .animation(.easeInOut, value: task.isDone)
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TaskRowView(task: TaskItem(title: "Example Task"), toggleAction: {})
                .padding()
                .previewLayout(.sizeThatFits)

            TaskRowView(task: TaskItem(title: "Done Task", isDone: true), toggleAction: {})
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
