-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_pep_acesso_atend ( nr_atendimento_p bigint, cd_pessoa_fisica_p text) AS $body$
DECLARE


cd_pessoa_fisica_w	varchar(10);
qt_reg_w		integer;
ie_libera_acesso_w	varchar(1);

C01 CURSOR FOR
	SELECT	cd_autorizador,
		cd_pessoa_fisica,
		dt_inicio,
		dt_fim,
		ds_motivo,
		nm_usuario
	from	pep_autor_acesso
	where	cd_paciente = cd_pessoa_fisica_p
	and (clock_timestamp()	between	coalesce(dt_inicio,to_date('01/01/1900','dd/mm/yyyy')) and coalesce(dt_fim,to_date('01/01/2900','dd/mm/yyyy')))
	and 	((coalesce(ie_libera_acesso_w,'N') = 'N') or((coalesce(ie_libera_acesso_w,'N') = 'S') and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')))
	and 	coalesce(dt_inativacao::text, '') = '';

c01_w		c01%rowtype;


BEGIN

/*select	count(*)
into	qt_reg_w
from	pep_autor_acesso
where	cd_pessoa_fisica = cd_pessoa_fisica_w
and	dt_fim	> sysdate;*/
SELECT	coalesce(MAX(IE_LIBERAR_ACESSOS_PEP),'N')
into STRICT	ie_libera_acesso_w
from	parametro_medico
where	cd_estabelecimento	= wheb_usuario_pck.get_cd_estabelecimento;

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	insert into pep_autor_acesso_atend( nr_sequencia,
						  cd_estabelecimento,
						  cd_autorizador,
						  nr_atendimento,
						  dt_atualizacao,
						  nm_usuario,
						  dt_atualizacao_nrec,
						  nm_usuario_nrec,
						  cd_pessoa_fisica,
						  dt_inicio,
						  dt_fim,
						  ds_motivo,
						  ie_liberacao
						)
						values ( nextval('pep_autor_acesso_atend_seq'),
						  wheb_usuario_pck.get_cd_estabelecimento,
						  c01_w.cd_autorizador,
						  nr_atendimento_p,
						  clock_timestamp(),
						  c01_w.nm_usuario,
						  clock_timestamp(),
						  c01_w.nm_usuario,
						  c01_w.cd_pessoa_fisica,
						  c01_w.dt_inicio,
						  c01_w.dt_fim,
						  c01_w.ds_motivo,
						  'S'
						);

	end;
end loop;
close C01;





end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_pep_acesso_atend ( nr_atendimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

