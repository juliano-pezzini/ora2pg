-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_cadastro_paciente_js ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 cd_pessoa_fisica_w  varchar(10);
 cd_estabelecimento_w smallint;
 nm_paciente_w    varchar(80);

BEGIN
 if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')then  
  update gestao_vaga 
  set  dt_atualizacao_cadastro_pf = clock_timestamp(), 
      nm_usuario_atual_cadastro_pf = nm_usuario_p, 
      ie_atual_cadastro = 'S' 
  where nr_sequencia = nr_sequencia_p;
 
  select cd_pessoa_fisica, 
      cd_estabelecimento, 
      nm_paciente 
  into STRICT  cd_pessoa_fisica_w, 
      cd_estabelecimento_w, 
      nm_paciente_w 
  from  gestao_vaga 
  where nr_sequencia = nr_sequencia_p; 	
   
  CALL gerar_evento_gestao_vaga_sms(cd_pessoa_fisica_w, nm_usuario_p, cd_estabelecimento_w, nr_sequencia_p, nm_paciente_w);
 end if;
 commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_cadastro_paciente_js ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

