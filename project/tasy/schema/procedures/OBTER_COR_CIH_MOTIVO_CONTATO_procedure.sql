-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_cor_cih_motivo_contato ( nm_usuario_p text, nr_seq_cor_lista_p INOUT text, ds_cor_lista_p INOUT text) AS $body$
DECLARE


ds_sql_w	varchar(255);


BEGIN

ds_sql_w		:= 'select nr_sequencia from cih_motivo_contato';
nr_seq_cor_lista_p	:= obter_select_concatenado_bv(ds_sql_w, '', ',');

ds_sql_w		:= 'select ds_cor from cih_motivo_contato order by nr_sequencia';
ds_cor_lista_p	:= obter_select_concatenado_bv(ds_sql_w, '', ',');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_cor_cih_motivo_contato ( nm_usuario_p text, nr_seq_cor_lista_p INOUT text, ds_cor_lista_p INOUT text) FROM PUBLIC;

