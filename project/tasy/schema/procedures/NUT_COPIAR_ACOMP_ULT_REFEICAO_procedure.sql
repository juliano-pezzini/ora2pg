-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_copiar_acomp_ult_refeicao ( cd_setor_atendimento_p bigint, cd_refeicao_filtro_p text, dt_dieta_p timestamp, nm_usuario_p text ) AS $body$
DECLARE


nr_sequencia_w		bigint;
cd_refeicao_w		varchar(10);
C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	mapa_dieta a
	where	coalesce(a.nr_seq_superior::text, '') = ''
	and	a.ie_destino_dieta 	 = 'A'
	and	a.cd_refeicao 		 = cd_refeicao_w
	and	((a.cd_setor_atendimento = cd_setor_atendimento_p) or (cd_setor_atendimento_p = 0))
	and	dt_dieta_p 		= trunc(a.dt_dieta)
	and	not exists(	SELECT	1
				from	mapa_dieta y
				where	coalesce(y.nr_seq_superior::text, '') = ''
				and	y.ie_destino_dieta 	 = 'A'
				and	y.cd_refeicao 		 = cd_refeicao_filtro_p
				and	y.cd_pessoa_fisica	 = a.cd_pessoa_fisica
				and	((y.cd_setor_atendimento = cd_setor_atendimento_p) or (cd_setor_atendimento_p = 0))
				and	dt_dieta_p 		 = trunc(y.dt_dieta));


BEGIN
SELECT 	MAX(a.cd_refeicao)
into STRICT	cd_refeicao_w
FROM	mapa_dieta a
WHERE 	coalesce(a.nr_seq_superior::text, '') = ''
AND	a.ie_destino_dieta 	 = 'A'
AND	((a.cd_setor_atendimento = cd_setor_atendimento_p) OR (cd_setor_atendimento_p = 0))
AND	a.dt_atualizacao_nrec 	 = (	SELECT	MAX(b.dt_atualizacao_nrec)
					FROM	mapa_dieta b
					WHERE 	coalesce(b.nr_seq_superior::text, '') = ''
					AND	b.ie_destino_dieta 	 = 'A'
					AND	((b.cd_setor_atendimento = cd_setor_atendimento_p) OR (cd_setor_atendimento_p = 0))
					and	trunc(b.dt_dieta) = dt_dieta_p);


open C01;
loop
fetch C01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	insert into mapa_dieta(
				nr_sequencia,
				cd_pessoa_fisica,
				dt_dieta,
				cd_refeicao,
				ie_destino_dieta,
				ie_status,
				dt_atualizacao,
				nm_usuario,
				cd_setor_atendimento,
				cd_unidade_basica,
				cd_unidade_compl,
				cd_dieta,
				ds_observacao,
				nr_atendimento,
				qt_parametro,
				dt_atualizacao_nrec,
				nm_usuario_nrec)
		SELECT		nextval('mapa_dieta_seq'),
				cd_pessoa_fisica,
				dt_dieta_p,
				cd_refeicao_filtro_p,
				ie_destino_dieta,
				ie_status,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento_p,
				cd_unidade_basica,
				cd_unidade_compl,
				cd_dieta,
				ds_observacao,
				nr_atendimento,
				qt_parametro,
				clock_timestamp(),
				nm_usuario_p
	from			mapa_dieta
	where			nr_sequencia = nr_sequencia_w;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_copiar_acomp_ult_refeicao ( cd_setor_atendimento_p bigint, cd_refeicao_filtro_p text, dt_dieta_p timestamp, nm_usuario_p text ) FROM PUBLIC;

