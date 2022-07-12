-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.elimina_carac_inv ( ds_xml_p INOUT pls_lote_sip.ds_conteudo_hash%type) AS $body$
DECLARE


tb_char_inv_w		dbms_sql.varchar2_table;
tb_char_troca_w		dbms_sql.varchar2_table;

ds_acento_w		varchar(68) := obter_desc_expressao(1035114);
ds_novo_w		varchar(68) := 'a,a,a,a,a,e,e,e,i,i,o,o,o,u,u,u,c,A,A,A,A,A,E,E,E,I,I,O,O,O,U,U,U,C';

cs_converte_lista CURSOR(	ds_lista_pc	text,
				ds_separador_pc	text) FOR
	SELECT	ds_valor_vchr2
	from	table(pls_util_pck.converter_lista_valores(ds_lista_pc, ds_separador_pc));

BEGIN

if (ds_xml_p IS NOT NULL AND ds_xml_p::text <> '') then
		
	ds_xml_p	:= replace(ds_xml_p, chr(13),  ''); -- Retorno de carro
	ds_xml_p	:= replace(ds_xml_p, chr(10),  ''); -- New Line
	ds_xml_p	:= replace(ds_xml_p, chr(9),  ''); -- e tabulacao nao devem estar no arquivo.

	-- Carregar os dados dos caracteres a serem removidos.

	open cs_converte_lista(ds_acento_w, ',');
	fetch cs_converte_lista bulk collect into tb_char_inv_w;
	close cs_converte_lista;
	-- Carregar os dados dos caracteres para substituir.

	open cs_converte_lista(ds_novo_w, ',');
	fetch cs_converte_lista bulk collect into tb_char_troca_w;
	close cs_converte_lista;
	
	-- Percorrer os caracteres e trocar cada um pelo seu equivalente sem acento.

	for i in tb_char_inv_w.first..tb_char_inv_w.last loop
		
		-- Substituir o caractere antigo pelo novo.

		ds_xml_p	:= replace(ds_xml_p, tb_char_inv_w(i),  tb_char_troca_w(i));
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.elimina_carac_inv ( ds_xml_p INOUT pls_lote_sip.ds_conteudo_hash%type) FROM PUBLIC;
