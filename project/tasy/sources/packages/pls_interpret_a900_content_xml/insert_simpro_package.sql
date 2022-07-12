-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_interpret_a900_content_xml.insert_simpro ( reg_mat_simpro_aux_p reg_mat_simpro, nr_seq_mat_med_unimed_p w_pls_material_unimed.nr_sequencia%type ) AS $body$
BEGIN

insert into w_pls_mat_unimed_simpro(
    nr_sequencia,           dt_atualizacao,     nm_usuario,
    dt_atualizacao_nrec,    nm_usuario_nrec,    nr_seq_mat_unimed,
    cd_simpro,              desc_prod_simpro )
values (
    nextval('w_pls_mat_unimed_simpro_seq'),        clock_timestamp(),                                    reg_mat_simpro_aux_p.nm_usuario_w,
    clock_timestamp(),                                    reg_mat_simpro_aux_p.nm_usuario_w,          nr_seq_mat_med_unimed_p,
    reg_mat_simpro_aux_p.cd_simpro_w,           reg_mat_simpro_aux_p.ds_produto_simpro_w );

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_interpret_a900_content_xml.insert_simpro ( reg_mat_simpro_aux_p reg_mat_simpro, nr_seq_mat_med_unimed_p w_pls_material_unimed.nr_sequencia%type ) FROM PUBLIC;