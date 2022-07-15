-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE iniciar_triagem_pa ( nr_seq_triagem_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

        
ds_erro_w    varchar(255);


BEGIN

if (nr_seq_triagem_p IS NOT NULL AND nr_seq_triagem_p::text <> '') then

  update  triagem_pronto_atend
  set    dt_inicio_triagem  =  clock_timestamp()
  where  nr_sequencia    =  nr_seq_triagem_p;


  begin
    CALL gerar_log_triagem_pa( null,'I',nm_usuario_p, NULL, 'N', NULL, nr_seq_triagem_p);
  exception
  when others then
    ds_erro_w  := substr(sqlerrm,1,255);
  end;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE iniciar_triagem_pa ( nr_seq_triagem_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

