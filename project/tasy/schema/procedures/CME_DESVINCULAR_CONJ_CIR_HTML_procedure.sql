-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_desvincular_conj_cir_html (cd_barras_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, nr_seq_pepo_p bigint, ie_estrutura_pepo_p text) AS $body$
DECLARE

 
nr_seq_pepo_w	cirurgia.nr_seq_pepo%type;


BEGIN 
 
nr_seq_pepo_w := null;
 
if (ie_estrutura_pepo_p = 'S') then 
	nr_seq_pepo_w := nr_seq_pepo_p;
end if;
 
CALL CME_Desvincular_Conj_Cirurgia(cd_barras_p, nr_cirurgia_p, nm_usuario_p, nr_seq_pepo_w);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_desvincular_conj_cir_html (cd_barras_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, nr_seq_pepo_p bigint, ie_estrutura_pepo_p text) FROM PUBLIC;

