<%@ page import="java.sql.*" %>
<%@ page import="items.Book" %>
<%@ page import="java.util.*" %>
<%@ page import="items.Item" %>
<%@ page import="items.Magazine" %>
<%@ page import="items.Book" %>
<%@ page import="items.Magazine" %><%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 13.10.2020
  Time: 14:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<html>
<head>
    <title>Items</title>
    <link rel="stylesheet" href="css/items.css">
</head>
<body>
    <header>
        <h1 style="margin-left: 3vw;">Hello, <c:out value="${sessionScope.user}"/>!</h1>
        <div class="buttons">
            <div><a href="cart.jsp" class="button" style="text-decoration: none;">Shopping cart</a></div>
            <div><a href="logout.jsp" class="button" style="text-decoration: none;">Log out</a></div>
        </div>
    </header>
    <div id="tables">
    <%
        Deque<Item> itemDeque = new LinkedList<>();
        int n=0, m=0;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/bookonline?serverTimezone=UTC","root","");
            PreparedStatement pst = con.prepareStatement("select * from book");
            ResultSet rs=pst.executeQuery();
            while(rs.next()) {
                Book book = new Book(rs.getInt("id"),rs.getString("name"),rs.getString("author"),rs.getString("genre"),rs.getInt("price"));
                itemDeque.addFirst(book);
                n++;
            }
            pst = con.prepareStatement("select * from magazine");
            rs=pst.executeQuery();
            while(rs.next()) {
                Magazine magazine = new Magazine(rs.getInt("id"),rs.getString("name"),rs.getString("author"),rs.getString("genre"),rs.getInt("price"));
                itemDeque.addFirst(magazine);
                m++;
            }
        } catch(Exception e) {
            out.println(e);
        }
        Book[] bookArray = new Book[n];
        Magazine[] magazineArray = new Magazine[m];
        for (int i=0; i<m; i++) {
            magazineArray[i]= (Magazine) itemDeque.pollFirst();
        }
        for (int i=0; i<n; i++) {
            bookArray[i]= (Book) itemDeque.pollFirst();
        }
        for (int i=0; i<n; i++) {
            for (int j=0; j<n-1; j++) {
                if (bookArray[j].compareTo(bookArray[j+1]) == -1) {
                    Book temp = bookArray[j];
                    bookArray[j] = bookArray[j+1];
                    bookArray[j+1] = temp;
                }
            }
        }
        for (int i=0; i<m; i++) {
            for (int j=0; j<m-1; j++) {
                if (magazineArray[j].compareTo(magazineArray[j+1]) == -1) {
                    Magazine temp = magazineArray[j];
                    magazineArray[j] = magazineArray[j+1];
                    magazineArray[j+1] = temp;
                }
            }
        }
        Deque<Book> bookList = new ArrayDeque<>();
        Deque<Magazine> magazineList = new ArrayDeque<>();
        out.println("<div><h2>Book list</h2><table class='blueTable'>" +
                "<thead><tr><th>Name</th><th>Author</th><th>Genre</th><th>Price</th></tr></thead><tbody>");
        for (int i=0; i<n; i++) {
            bookList.addLast(bookArray[i]);
            out.println("<tr><td>"+ bookList.getLast().getName()+"</td>" +
                    "<td>"+ bookList.getLast().getAuthor()+"</td>" +
                    "<td>"+ bookList.getLast().getGenre()+"</td>" +
                    "<td><form method='post' action='PurchaseBookServlet'>"+
                    "<input name='id' type='text' style='display: none;' value='"+
                    bookList.getLast().getId()+"'>"+
                    "<input class='purchase' type='submit' value='"+
                    " $"+ bookList.getLast().getPrice()+"'></form>" +
                    "</td></tr></tbody>");
        }
        out.println("</table></div>");
        out.println("<div><h2>Magazine list</h2><table class='blueTable'>" +
                "<thead><tr><th>Name</th><th>Author</th><th>Genre</th><th>Price</th></tr></thead><tbody>");
        for (int i=0; i<m; i++) {
            magazineList.addLast(magazineArray[i]);
            out.println("<tr><td>"+ magazineList.getLast().getName()+"</td>" +
                    "<td>"+ magazineList.getLast().getAuthor()+"</td>" +
                    "<td>"+ magazineList.getLast().getGenre()+"</td>" +
                    "<td><form method='post' action='PurchaseMagazineServlet'>"+
                    "<input name='id' type='text' style='display: none;' value='"+
                    magazineList.getLast().getId()+"'>" +
                    "<input class='purchase' type='submit' value='"+
                    " $"+ magazineList.getLast().getPrice()+"'></form>" +
                    "</td></tr></tbody>");
        }
        out.println("</table></div>");
    %>
    </div>
</body>
</html>
