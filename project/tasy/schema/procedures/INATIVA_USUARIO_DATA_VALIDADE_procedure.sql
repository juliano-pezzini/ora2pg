-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativa_usuario_data_validade (nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

/*  Inativa/Boqueia o usuário verificando a data atual com o atributo DT_VALIDADE_USUARIO na entidade USUARIO  */

nm_usuario_w		varchar(15);
dt_validade_usuario_w	timestamp;
ie_inativa_w   		varchar(1);
ie_houve_alteracao_w	boolean := False;

c01 CURSOR FOR
SELECT	a.nm_usuario,
       	a.dt_validade_usuario
from 	usuario a
where 	a.ie_situacao		= 'A'
and 	(a.dt_validade_usuario IS NOT NULL AND a.dt_validade_usuario::text <> '')
and 	a.dt_validade_usuario < clock_timestamp()
order by 1;


BEGIN
/* Parâmetro 130 do Menu do sistema*/

ie_inativa_w := obter_param_usuario(0, 130, 0, nm_usuario_p, cd_estabelecimento_p, ie_inativa_w);
if (ie_inativa_w = 'S') then
  	open C01;
	loop
	fetch C01 into
		nm_usuario_w,
		dt_validade_usuario_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		update  usuario
		set 	ie_situacao 		= 'I',
			dt_atualizacao 		= clock_timestamp(),
			nm_usuario_atual 	= nm_usuario_p,
			dt_inativacao		= clock_timestamp()
		where 	nm_usuario 		= nm_usuario_w;

		/*insert into logxxx_tasy(
			cd_log,
			ds_log,
			dt_atualizacao,
			nm_usuario)
		values(	55885,
			substr('Usuário: ' || nm_usuario_w || ' inativado/bloqueado automaticamente por JOB por estar com data de validade vencida.', 1, 1900),
			sysdate,
			nm_usuario_p);*/
		ie_houve_alteracao_w	:= True;
	end loop;
	close C01;
	if ie_houve_alteracao_w then
		commit;
	end if;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativa_usuario_data_validade (nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

