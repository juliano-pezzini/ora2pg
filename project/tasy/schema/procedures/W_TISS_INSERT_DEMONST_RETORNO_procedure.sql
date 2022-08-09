-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE w_tiss_insert_demonst_retorno ( nm_usuario_p text , ie_limpa_tabela_p text , nr_seq_demonstra_ret_p INOUT bigint) AS $body$
DECLARE


-- IE_LIMPA_TABELA_P: 'S' -  Limpar tabela / 'N' - Não limpar
nr_seq_demonstra_ret_w bigint;


BEGIN

if (ie_limpa_tabela_p = 'S') then

  delete 	from W_TISS_DEMONSTRA_RET_ITENS where	dt_atualizacao < clock_timestamp() - interval '1 days';
  commit;
  delete 	from W_TISS_DEMONSTRA_RETORNO 	where	dt_atualizacao < clock_timestamp() - interval '1 days';
  commit;

end if;

select  nextval('w_tiss_demonstra_retorno_seq')
into STRICT    nr_seq_demonstra_ret_w
;

insert into W_TISS_DEMONSTRA_RETORNO( dt_atualizacao,
              nm_usuario,
              nr_sequencia) values (
              clock_timestamp(),
              nm_usuario_p,
              nr_seq_demonstra_ret_w  );

nr_seq_demonstra_ret_p := nr_seq_demonstra_ret_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE w_tiss_insert_demonst_retorno ( nm_usuario_p text , ie_limpa_tabela_p text , nr_seq_demonstra_ret_p INOUT bigint) FROM PUBLIC;
