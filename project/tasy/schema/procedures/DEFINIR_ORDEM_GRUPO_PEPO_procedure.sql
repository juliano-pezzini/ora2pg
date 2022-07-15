-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE definir_ordem_grupo_pepo ( nr_cirurgia_p bigint, nr_seq_pepo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_item_grafico_w	bigint := 0;
ie_modo_adm_w		varchar(15);
/*
AA             |Agente anestésico
GP             |Ganhos e perdas
H              |Hemoderivados
M              |Medicamentos
MR             |Monitoração respiratória
SV             |Sinal vital
TH             |Terapia hidroeletrolitica
*/
nr_seq_apresent_w 	bigint := 0;
ie_ordem_tipo_w 		varchar(15);
ie_ordem_modo_adm_w 	varchar(15);
ie_grupo_selecionado_w 	varchar(15);
ie_grupo_item_pepo_w 	varchar(15);
nr_ordem_w		bigint := null;
cd_estabelecimento_w	bigint := wheb_usuario_pck.get_cd_estabelecimento;

c01 CURSOR FOR
	SELECT	ie_grupo_item_pepo,
			ie_ordem_tipo,
			ie_ordem_modo_adm,
			coalesce(ie_grupo_selecionado,'S'),
			nr_seq_apresent * 100
	from 	pepo_grupo_item_grafico
	where	nm_usuario 	= nm_usuario_p
	order by nr_seq_apresent;

c02 CURSOR FOR  --AA
	SELECT 	a.nr_sequencia,
			b.ie_modo_adm
	FROM   	pepo_item_grafico a,
			cirurgia_agente_anestesico b,
			agente_anestesico c
	WHERE  	a.nr_seq_cirur_agente 	= b.nr_sequencia
	AND		b.nr_seq_agente			= c.nr_sequencia
	AND	(((coalesce(nr_seq_pepo_p,0) > 0) AND (a.nr_seq_pepo = nr_seq_pepo_p))
	OR	((coalesce(nr_cirurgia_p,0) > 0) AND (a.nr_cirurgia = nr_cirurgia_p)))
	AND		b.ie_tipo				= 1;

c03 CURSOR FOR  --TH
	SELECT 	a.nr_sequencia,
			b.ie_modo_adm
	FROM   	pepo_item_grafico a,
			cirurgia_agente_anestesico b,
			agente_anestesico c
	WHERE  	a.nr_seq_cirur_agente 	= b.nr_sequencia
	AND		b.nr_seq_agente			= c.nr_sequencia
	AND	(((coalesce(nr_seq_pepo_p,0) > 0) AND (a.nr_seq_pepo = nr_seq_pepo_p))
	OR	((coalesce(nr_cirurgia_p,0) > 0) AND (a.nr_cirurgia = nr_cirurgia_p)))
	AND		b.ie_tipo				= 2;

c04 CURSOR FOR  --M
	SELECT 	a.nr_sequencia,
			b.ie_modo_adm
	FROM   	pepo_item_grafico a,
			cirurgia_agente_anestesico b,
			agente_anestesico c
	WHERE  	a.nr_seq_cirur_agente 	= b.nr_sequencia
	AND		b.nr_seq_agente			= c.nr_sequencia
	AND	(((coalesce(nr_seq_pepo_p,0) > 0) AND (a.nr_seq_pepo = nr_seq_pepo_p))
	OR	((coalesce(nr_cirurgia_p,0) > 0) AND (a.nr_cirurgia = nr_cirurgia_p)))
	AND		b.ie_tipo				= 3;

C05 CURSOR FOR  --H
	SELECT 	a.nr_sequencia,
			b.ie_modo_adm
	FROM   	pepo_item_grafico a,
			cirurgia_agente_anestesico b,
			san_derivado c
	WHERE  	a.nr_seq_cirur_agente 	= b.nr_sequencia
	AND		b.nr_seq_derivado		= c.nr_sequencia
	AND	(((coalesce(nr_seq_pepo_p,0) > 0) AND (a.nr_seq_pepo = nr_seq_pepo_p))
	OR	((coalesce(nr_cirurgia_p,0) > 0) AND (a.nr_cirurgia = nr_cirurgia_p)))
	AND		b.ie_tipo				= 5;


BEGIN
open C01;
loop
fetch C01 into
	ie_grupo_item_pepo_w,
	ie_ordem_tipo_w,
	ie_ordem_modo_adm_w,
	ie_grupo_selecionado_w,
	nr_seq_apresent_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		if (ie_grupo_item_pepo_w = 'AA') then
			open C02;
			loop
			fetch C02 into
				nr_seq_item_grafico_w,
				ie_modo_adm_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
				update	pepo_item_grafico
				set	nr_seq_apresentacao 	= CASE WHEN ie_ordem_tipo_w='GM' THEN CASE WHEN ie_modo_adm_w='CO' THEN  nr_seq_apresent_w  ELSE nr_seq_apresent_w + 50 END   ELSE CASE WHEN ie_modo_adm_w='CO' THEN (nr_seq_apresent_w/100) + 1  ELSE (nr_seq_apresent_w/100) + 10 END  END ,
				ie_grafico		= ie_grupo_selecionado_w
				where nr_sequencia	= nr_seq_item_grafico_w
				and	nm_usuario		= nm_usuario_p;
			end;
			end loop;
			close C02;
		elsif (ie_grupo_item_pepo_w = 'TH') then
			open C03;
			loop
			fetch C03 into
				nr_seq_item_grafico_w,
				ie_modo_adm_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
				update	pepo_item_grafico
				set	nr_seq_apresentacao 	= CASE WHEN ie_ordem_tipo_w='GM' THEN CASE WHEN ie_modo_adm_w='CO' THEN  nr_seq_apresent_w  ELSE nr_seq_apresent_w + 50 END   ELSE CASE WHEN ie_modo_adm_w='CO' THEN (nr_seq_apresent_w/100) + 1  ELSE (nr_seq_apresent_w/100) + 10 END  END ,
				ie_grafico		= ie_grupo_selecionado_w
				where nr_sequencia	= nr_seq_item_grafico_w
				and	nm_usuario		= nm_usuario_p;
			end;
			end loop;
			close C03;
		elsif (ie_grupo_item_pepo_w = 'M') then
			open C04;
			loop
			fetch C04 into
				nr_seq_item_grafico_w,
				ie_modo_adm_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
				update	pepo_item_grafico
				set	nr_seq_apresentacao 	= CASE WHEN ie_ordem_tipo_w='GM' THEN CASE WHEN ie_modo_adm_w='CO' THEN  nr_seq_apresent_w  ELSE nr_seq_apresent_w + 50 END   ELSE CASE WHEN ie_modo_adm_w='CO' THEN (nr_seq_apresent_w/100) + 1  ELSE (nr_seq_apresent_w/100) + 10 END  END ,
				ie_grafico		= ie_grupo_selecionado_w
				where nr_sequencia	= nr_seq_item_grafico_w
				and	nm_usuario		= nm_usuario_p;
			end;
			end loop;
			close C04;
		elsif (ie_grupo_item_pepo_w = 'H') then
			open C05;
			loop
			fetch C05 into
				nr_seq_item_grafico_w,
				ie_modo_adm_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */
			begin
				update	pepo_item_grafico
				set	nr_seq_apresentacao 	= CASE WHEN ie_ordem_tipo_w='GM' THEN CASE WHEN ie_modo_adm_w='CO' THEN  nr_seq_apresent_w  ELSE nr_seq_apresent_w + 50 END   ELSE CASE WHEN ie_modo_adm_w='CO' THEN (nr_seq_apresent_w/100) + 1  ELSE (nr_seq_apresent_w/100) + 10 END  END ,
				ie_grafico		= ie_grupo_selecionado_w
				where nr_sequencia	= nr_seq_item_grafico_w
				and	nm_usuario		= nm_usuario_p;
			end;
			end loop;
			close C05;
		elsif (ie_grupo_item_pepo_w = 'SV') then
			update	pepo_item_grafico a
			set		a.nr_seq_apresentacao 	= CASE WHEN ie_ordem_tipo_w='GM' THEN nr_seq_apresent_w  ELSE nr_seq_apresent_w + 100 END ,
					a.ie_grafico		= ie_grupo_selecionado_w
			where   exists (SELECT 1
							from pepo_sinal_vital b
							where a.nr_seq_sinal_vital = b.nr_sequencia
							and b.cd_estabelecimento = cd_estabelecimento_w
							and coalesce(b.ie_situacao,'A') 	= 'A'
							and b.nr_sequencia  not in (select nr_sequencia
									         		    from pepo_sinal_vital
									         		     where ((ie_sinal_vital = 'E') or (ie_sinal_vital = 'HI') or (ie_sinal_vital = 'HE') or (ie_sinal_vital = 'CAM') or (ie_sinal_vital = 'QTVCI') or (ie_sinal_vital = 'QTFREQVENT') or (ie_sinal_vital = 'QTPIP') or (ie_sinal_vital = 'QTFIO2') or (ie_sinal_vital = 'QTOXIGINS') or (ie_sinal_vital = 'QTNITROSO') or (ie_sinal_vital = 'PEEP'))))
			and		a.nm_usuario		= nm_usuario_p;
		elsif (ie_grupo_item_pepo_w = 'MR') then
			update	pepo_item_grafico a
			set		a.nr_seq_apresentacao 	= CASE WHEN ie_ordem_tipo_w='GM' THEN nr_seq_apresent_w  ELSE nr_seq_apresent_w + 100 END ,
					a.ie_grafico		= ie_grupo_selecionado_w
			where   exists (SELECT 1
							from pepo_sinal_vital b
							where a.nr_seq_sinal_vital 	= b.nr_sequencia
							and b.cd_estabelecimento 	= cd_estabelecimento_w
							and coalesce(b.ie_situacao,'A') 	= 'A'
							and b.nr_sequencia in (select nr_sequencia
												   from pepo_sinal_vital
												   where ((ie_sinal_vital = 'E') or (ie_sinal_vital = 'HI') or (ie_sinal_vital = 'HE') or (ie_sinal_vital = 'CAM') or (ie_sinal_vital = 'QTVCI') or (ie_sinal_vital = 'QTFREQVENT') or (ie_sinal_vital = 'QTPIP') or (ie_sinal_vital = 'QTFIO2') or (ie_sinal_vital = 'QTOXIGINS') or (ie_sinal_vital = 'QTNITROSO') or (ie_sinal_vital = 'PEEP'))))
			and		a.nm_usuario		= nm_usuario_p;
		elsif (ie_grupo_item_pepo_w = 'GP') then
			update	pepo_item_grafico
			set		nr_seq_apresentacao 	= CASE WHEN ie_ordem_tipo_w='GM' THEN nr_seq_apresent_w  ELSE nr_seq_apresent_w + 100 END ,
					ie_grafico		= ie_grupo_selecionado_w
			where	(nr_seq_tipo IS NOT NULL AND nr_seq_tipo::text <> '')
			and		nm_usuario		= nm_usuario_p;
		end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE definir_ordem_grupo_pepo ( nr_cirurgia_p bigint, nr_seq_pepo_p bigint, nm_usuario_p text) FROM PUBLIC;

