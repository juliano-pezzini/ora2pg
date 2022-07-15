-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_niss_exportacao (cd_interface_p niss_exportacao.cd_interface%type, ds_arquivo_p niss_exportacao.ds_arquivo%type, dt_inicial_p niss_exportacao.dt_inicial%type, dt_final_p niss_exportacao.dt_final%type, ds_observacao_p niss_exportacao.ds_observacao%type, nm_usuario_p niss_exportacao.nm_usuario%type) AS $body$
DECLARE

    nr_sequencia_w  niss_exportacao.nr_sequencia%type;

BEGIN

    select nextval('niss_exportacao_seq')
    into STRICT nr_sequencia_w 
;

    insert into niss_exportacao(nr_sequencia,
                                cd_interface,
                                ds_arquivo,
                                dt_inicial,
                                dt_final,
                                ds_observacao,
                                dt_atualizacao,
                                nm_usuario,
                                dt_atualizacao_nrec,
                                nm_usuario_nrec)
                         values (nr_sequencia_w,
                                cd_interface_p,
                                ds_arquivo_p,
                                dt_inicial_p,
                                dt_final_p,
                                ds_observacao_p,
                                clock_timestamp(),
                                nm_usuario_p,
                                clock_timestamp(),
                                nm_usuario_p);

    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_niss_exportacao (cd_interface_p niss_exportacao.cd_interface%type, ds_arquivo_p niss_exportacao.ds_arquivo%type, dt_inicial_p niss_exportacao.dt_inicial%type, dt_final_p niss_exportacao.dt_final%type, ds_observacao_p niss_exportacao.ds_observacao%type, nm_usuario_p niss_exportacao.nm_usuario%type) FROM PUBLIC;

