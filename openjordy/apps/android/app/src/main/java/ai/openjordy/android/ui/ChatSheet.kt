package ai.openjordy.android.ui

import androidx.compose.runtime.Composable
import ai.openjordy.android.MainViewModel
import ai.openjordy.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}
