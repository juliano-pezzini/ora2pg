-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_grupos_padrao_contrato ( nr_seq_contrato_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_setor_atendimento_w	integer;
ie_aviso_revisao_w	varchar(1);
ie_aviso_vencimento_w	varchar(1);
ie_permite_acesso_w	varchar(1);
nr_seq_grupo_w		bigint;
qt_registros_w		bigint;
nm_usuario_lib_w	usuario.nm_usuario%type;
cd_perfil_w		perfil.cd_perfil%type;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		ie_aviso_revisao,
		ie_aviso_vencimento,
		ie_permite_acesso
	from	regra_liberacao_contrato
	where	ie_grupo_padrao = 'S';

c02 CURSOR FOR
	SELECT	cd_setor_atendimento,
		nm_usuario_lib,
		cd_perfil
	from	regra_lib_contrato_setor
	where	nr_seq_regra_lib = nr_seq_grupo_w;


BEGIN

select	coalesce(count(*),0)
into STRICT	qt_registros_w
from	regra_liberacao_contrato
where	ie_grupo_padrao = 'S';

if (qt_registros_w > 0) then

	open c01;
	loop
	fetch c01 into
		nr_seq_grupo_w,
		ie_aviso_revisao_w,
		ie_aviso_vencimento_w,
		ie_permite_acesso_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		open c02;
		loop
		fetch c02 into
			cd_setor_atendimento_w,
			nm_usuario_lib_w,
			cd_perfil_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			select	coalesce(count(*),0)
			into STRICT	qt_registros_w
			from	contrato_usuario_lib
			where	nr_seq_contrato = nr_seq_contrato_p
			and	cd_setor = cd_setor_atendimento_w;

			if (qt_registros_w = 0) then

				insert into contrato_usuario_lib(	nr_sequencia,
										nr_seq_contrato,
										dt_atualizacao,
										nm_usuario,
										nm_usuario_lib,
										ie_aviso_vencimento,
										cd_perfil,
										cd_setor,
										ie_permite,
										ie_aviso_revisao,
										IE_GERACAO)
								values (	nextval('contrato_usuario_lib_seq'),
										nr_seq_contrato_p,
										clock_timestamp(),
										nm_usuario_p,
										nm_usuario_lib_w,
										ie_aviso_vencimento_w,
										cd_perfil_w,
										cd_setor_atendimento_w,
										ie_permite_acesso_w,
										ie_aviso_revisao_w,
										'U');
			end if;

			end;
		end loop;
		close c02;

		end;
	end loop;
	close c01;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_grupos_padrao_contrato ( nr_seq_contrato_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

