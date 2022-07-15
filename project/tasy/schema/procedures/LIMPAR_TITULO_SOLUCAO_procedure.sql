-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_titulo_solucao (nr_prescricao_p bigint, nr_seq_solucao_p bigint) AS $body$
DECLARE


ds_erro_w	varchar(2000);


BEGIN

update	prescr_solucao
set 	ds_solucao  = NULL
where 	nr_prescricao = nr_prescricao_p
and	nr_seq_solucao = nr_seq_solucao_p;

commit;

ds_erro_w := Consistir_prescr_solucao(nr_prescricao_p, nr_seq_solucao_p, wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, ds_erro_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_titulo_solucao (nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;

