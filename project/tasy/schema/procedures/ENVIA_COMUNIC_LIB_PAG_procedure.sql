-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_comunic_lib_pag ( nm_usuario_p text, cd_estabelecimento_p text) AS $body$
DECLARE





nr_seq_regra_w				bigint;
cd_perfil_w				varchar(10);
ds_setor_adicional_w			varchar(4000) := '';
cd_setor_regra_usuario_w			integer;
nm_usuario_destino_w			varchar(255);
qt_existe_w				bigint;
nr_sequencia_w				numeric(20);
nr_seq_classif_w				bigint;
ds_titulo_w				varchar(4000);
ds_comunicado_w				varchar(4000);
vl_titulo_w				double precision;


c01 CURSOR FOR
SELECT	b.nr_sequencia,
	b.cd_perfil
from	fin_regra_envio_comunic a,
	fin_regra_comunic_evento b
where	a.nr_sequencia = b.nr_seq_regra
and	a.cd_funcao = 857
and	b.cd_evento = 3
and	b.ie_situacao = 'A'
and	a.cd_estabelecimento = cd_estabelecimento_p;

c02 CURSOR FOR
SELECT	coalesce(a.cd_setor_atendimento,0) cd_setor_atendimento
from	fin_regra_comunic_usu a
where	a.nr_seq_evento = nr_seq_regra_w;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	fin_regra_envio_comunic a,
	fin_regra_comunic_evento b
where	a.nr_sequencia = b.nr_seq_regra
and	a.cd_funcao = 857
and	b.cd_evento = 3
and	b.ie_situacao = 'A'
and	cd_estabelecimento = cd_estabelecimento_p;

if (qt_existe_w > 0) then
	open c01;
	loop
	fetch c01 into
		nr_seq_regra_w,
		cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		open c02;
		loop
		fetch c02 into
			cd_setor_regra_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			if (cd_setor_regra_usuario_w <> 0) and (obter_se_contido_char(cd_setor_regra_usuario_w, ds_setor_adicional_w) = 'N') then
				ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_regra_usuario_w || ',',1,2000);
			end if;
		end;
		end loop;
		close c02;

		select	obter_classif_comunic('F')
		into STRICT	nr_seq_classif_w
		;

		select	max(substr(ds_titulo,1,80)),
			max(substr(ds_comunicacao,1,3000)) ds_comunicacao
		into STRICT	ds_titulo_w,
			ds_comunicado_w
		from	fin_regra_comunic_evento
		where	nr_sequencia = nr_seq_regra_w;

		SELECT	max(nm_usuarios_adic)
		INTO STRICT	nm_usuario_destino_w
		FROM	fin_regra_comunic_evento a
		WHERE	nr_sequencia = nr_seq_regra_w
		AND	a.ie_situacao = 'A';

		select	nextval('comunic_interna_seq')
		into STRICT	nr_sequencia_w
		;

		nm_usuario_destino_w := nm_usuario_destino_w;

		INSERT INTO comunic_interna(
					dt_comunicado,
					ds_titulo,
					ds_comunicado,
					nm_usuario,
					dt_atualizacao,
					ie_geral,
					nm_usuario_destino,
					nr_sequencia,
					ie_gerencial,
					nr_seq_classif,
					dt_liberacao,
					ds_perfil_adicional,
					ds_setor_adicional)
				VALUES (	clock_timestamp(),
					ds_titulo_w,
					ds_comunicado_w,
					nm_usuario_p,
					clock_timestamp(),
					'N',
					nm_usuario_destino_w,
					nr_sequencia_w,
					'N',
					nr_seq_classif_w,
					clock_timestamp(),
					cd_perfil_w,
					ds_setor_adicional_w);
		commit;

		end;
	end loop;
	close c01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE envia_comunic_lib_pag ( nm_usuario_p text, cd_estabelecimento_p text) FROM PUBLIC;

