-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_adicionar_prot_valid_xml ( nr_seq_protocolo_p bigint, nr_seq_tiss_prot_guia_p bigint, nr_seq_erro_valid_xml_p bigint, nr_linha_p bigint, nr_coluna_p bigint, ds_erro_adic_p text, nm_usuario_p text ) AS $body$
DECLARE

							
							
nr_sequencia_w	tiss_prot_guia_valid_xml.nr_sequencia%type;


BEGIN

delete from tiss_prot_guia_valid_xml
where nr_seq_protocolo = nr_seq_protocolo_p;

select nextval('tiss_prot_guia_valid_xml_seq')
into STRICT nr_sequencia_w
;

insert into tiss_prot_guia_valid_xml(nr_sequencia,
	dt_atualizacao,     
	nm_usuario,    
	dt_atualizacao_nrec,
	nm_usuario_nrec,     
	nr_seq_protocolo,
	nr_seq_erro_valid_xml,
	nr_linha,     
	nr_coluna,     
	ds_erro_adic)
values (nr_sequencia_w,    
	clock_timestamp(),    
	nm_usuario_p,     
	clock_timestamp(),
	nm_usuario_p,     
	nr_seq_protocolo_p,
	nr_seq_erro_valid_xml_p,
	nr_linha_p,     
	nr_coluna_p,     
	ds_erro_adic_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_adicionar_prot_valid_xml ( nr_seq_protocolo_p bigint, nr_seq_tiss_prot_guia_p bigint, nr_seq_erro_valid_xml_p bigint, nr_linha_p bigint, nr_coluna_p bigint, ds_erro_adic_p text, nm_usuario_p text ) FROM PUBLIC;

