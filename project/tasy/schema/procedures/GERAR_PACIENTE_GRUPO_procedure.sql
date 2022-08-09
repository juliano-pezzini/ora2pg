-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_paciente_grupo (cd_doenca_cid_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nm_usuario_p text) AS $body$
DECLARE


c01 CURSOR FOR

SELECT   nr_seq_grupo

from 	pac_grupo_auto a , cid_doenca b

      where a.cd_doenca_cid = b. cd_doenca_cid 

      and a.cd_doenca_cid = cd_doenca_cid_p


union


SELECT   nr_seq_grupo  

from 	pac_grupo_auto  a,

      cid_categoria b,

      cid_doenca c

      where	b.cd_categoria_cid 	= c.cd_categoria_cid
      
      and  b.cd_categoria_cid = a.cd_doenca_cid 
      
      and	c.cd_doenca_cid	= cd_doenca_cid_p;

BEGIN


for r_c01 in c01 loop

	begin

	CALL vincular_atendimento_grupo(null,cd_pessoa_fisica_p,1,r_c01.nr_seq_grupo,nm_usuario_p);

	end;

end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_paciente_grupo (cd_doenca_cid_p text, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nm_usuario_p text) FROM PUBLIC;
