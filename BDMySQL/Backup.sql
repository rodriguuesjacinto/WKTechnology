-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: database-1.ctquhawkwbqz.us-east-1.rds.amazonaws.com    Database: bdnovo
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- GTID state at the beginning of the backup 
--


--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `idclientes` int unsigned NOT NULL AUTO_INCREMENT,
  `cli_nome` varchar(100) NOT NULL,
  `cli_cidade` varchar(100) DEFAULT NULL,
  `cli_uf` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`idclientes`),
  KEY `ind_cli_nome` (`cli_nome`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'ROBERTO RODRIGUES','MARINGA','PR'),(2,'ROBERTO RODRIGUES','MARINGA','PR'),(3,'JAQUELINE DOS SANTOS','MARINGA','PR'),(4,'MARIO RODRIGUES','GRAMADO','RS'),(5,'ANDRE MARQUES','CAXIAS DO SUL','RS'),(6,'BRUNO OLIVEIRA NETO','RIO DE JANEIRO','RJ'),(7,'SAMUEL DE CASTRO','FLORIANOPOLIS','SC'),(8,'RICARDO DELGADO','VALENCIA','SC'),(9,'RITA SOUZA','RIO PEQUENO','AM'),(10,'AMANDA CUNHA','PALMAS','TO'),(11,'FELIPE DE CASTRO','CURITIBA','PR'),(12,'ALVARO DA SILVA','LOMRINA','SC'),(13,'MUNHOS DE SOUZA','ATALAIA','AM'),(14,'BENEDITO DA COSTA','MARINGA','AL'),(15,'FABRICIO OLIVEIRA','RIO BONITO','DF'),(16,'RONALDO ROCA','SAPIRANGA','MG'),(17,'GAEL DE SERGUEI','SOROCABA','RS'),(18,'BERENICE SOARES','CAMPINAS','SP'),(19,'SILVIO SANTOS','MARINGA','PR'),(20,'MARCOS OLIVEIRA','FLORIANOPOLS','RS'),(21,'ODETE CANARÃO','ATIBAIA','RJ'),(22,'SAMIRA ALAUDE','JANGADA','SC'),(23,'HENRRIQUE DIAS','JURUNA','SC'),(24,'BARBARA DA SILBA','BRUSCK','AM'),(25,'ALEXANDRE CARVALHO','JURUNA','TO');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `parametros`
--

DROP TABLE IF EXISTS `parametros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `parametros` (
  `idparametros` int unsigned NOT NULL AUTO_INCREMENT,
  `numerodopedido` int DEFAULT NULL,
  PRIMARY KEY (`idparametros`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `parametros`
--

LOCK TABLES `parametros` WRITE;
/*!40000 ALTER TABLE `parametros` DISABLE KEYS */;
INSERT INTO `parametros` VALUES (1,1);
/*!40000 ALTER TABLE `parametros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `idpedidos` int unsigned NOT NULL,
  `idclientes` int unsigned NOT NULL,
  `ped_dataemissao` date NOT NULL,
  `ped_valortotal` double NOT NULL,
  PRIMARY KEY (`idpedidos`),
  KEY `ind_idclientes` (`idclientes`),
  CONSTRAINT `fk_pedidos_e_clientes` FOREIGN KEY (`idclientes`) REFERENCES `clientes` (`idclientes`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`%`*/ /*!50003 TRIGGER `pedidos_BEFORE_INSERT` BEFORE INSERT ON `pedidos` FOR EACH ROW BEGIN
   set New.idpedidos = (select numerodopedido from parametros where idparametros = 1) ;
   update parametros set  numerodopedido = numerodopedido + 1   where idparametros = 1 ;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pedidos_itens`
--

DROP TABLE IF EXISTS `pedidos_itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_itens` (
  `idpedidos_itens` int unsigned NOT NULL AUTO_INCREMENT,
  `idpedidos` int unsigned DEFAULT NULL,
  `idprodutos` int unsigned NOT NULL,
  `ite_quantidade` double NOT NULL,
  `ite_valorunitario` double NOT NULL,
  `ite_valortotal` double NOT NULL,
  PRIMARY KEY (`idpedidos_itens`),
  KEY `ind_idpedidos` (`idpedidos`),
  KEY `ind_idprodutos` (`idprodutos`),
  CONSTRAINT `fk_pedidositens_e_pedidos` FOREIGN KEY (`idpedidos`) REFERENCES `pedidos` (`idpedidos`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pedidositens_e_produtos` FOREIGN KEY (`idprodutos`) REFERENCES `produtos` (`idprodutos`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_itens`
--

LOCK TABLES `pedidos_itens` WRITE;
/*!40000 ALTER TABLE `pedidos_itens` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos_itens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `idprodutos` int unsigned NOT NULL AUTO_INCREMENT,
  `prod_nome` varchar(100) NOT NULL,
  `prod_valorparavenda` double NOT NULL,
  PRIMARY KEY (`idprodutos`),
  KEY `ind_prod_nome` (`prod_nome`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'BATATA PALHA 330GM',5.8),(2,'FARINHA DE TRIGO',25.8),(3,'FARINHA DE MILHO',15.8),(4,'FARINHA DE TRIGO',25.8),(5,'FLOCOS DE MILHO',5.8),(6,'FARINHA DE TRIGO',25.8),(7,'FLOCOS DE MILHO',5.8),(8,'BALINLHA',2.3),(9,'DETERGENTE IP 900ML',1.8),(10,'ARROS ZAELY 5 KG',25.8),(11,'FEIJAO OURO VERDE',15.8),(12,'SORVETO 1 KG',2.8),(13,'BANANA KL',5.3),(14,'TOLHA DE PAPEL',2.5),(15,'BOMBRIL',5.8),(16,'BETERRABA EM CALDA',2.8),(17,'GOIABADA EM LATA',1.8),(18,'CREME DE LEITE',5.8),(19,'LEITE EM PO',15.8),(20,'LEITE DE COCO',25.8),(21,'LARANJA',15),(22,'CHINELO HAVAINAS',25.8),(23,'BISS',15.8),(24,'AGUA POTAVEL',25.8),(25,'MACARRAO GALO',15.8),(26,'BATATA',25.8),(27,'OVOS 30 UN',15.8),(28,'BOLACHA DE SAL',25.8),(29,'PAO DE FORMA',15.8),(30,'LINGUIÇA',25.8),(31,'LEITE NESTLE LATA',15.8),(32,'IORGUTE',25.8),(33,'LARANJA',15.8),(34,'BORRACHA BRANCA',25.8),(35,'CHINELO VERDE',15.8);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'bdnovo'
--

--
-- Dumping routines for database 'bdnovo'
--

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-08 16:30:52
