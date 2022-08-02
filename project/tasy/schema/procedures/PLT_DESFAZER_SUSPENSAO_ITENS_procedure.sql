-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_desfazer_suspensao_itens ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_tabela_p text, dt_suspensao_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_prescricao_w			bigint;
nr_seq_orig_w			bigint;
nr_prescr_orig_w		bigint;
nr_atendimento_w		bigint;
cd_pessoa_fisica_w		varchar(10);

c01 CURSOR FOR
SELECT	a.nr_prescricao,
	a.nr_sequencia
from	prescr_material a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao			= nr_prescr_orig_w
and	a.nr_sequencia			= nr_seq_orig_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_sequencia
from	prescr_material a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.nr_atendimento		= nr_atendimento_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_sequencia
from	prescr_material a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
and	a.dt_suspensao			>= dt_suspensao_p
and	coalesce(b.nr_atendimento::text, '') = ''
and	coalesce(nr_atendimento_w::text, '') = '';

c02 CURSOR FOR
SELECT	a.nr_prescricao,
	a.nr_sequencia
from	prescr_dieta a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao			= nr_prescr_orig_w
and	a.nr_sequencia			= nr_seq_orig_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_sequencia
from	prescr_dieta a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.nr_atendimento		= nr_atendimento_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_sequencia
from	prescr_dieta a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
and	a.dt_suspensao			>= dt_suspensao_p
and	coalesce(b.nr_atendimento::text, '') = ''
and	coalesce(nr_atendimento_w::text, '') = '';

c03 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_prescricao
from	rep_jejum a
where	a.nr_sequencia			= nr_seq_orig_w
and	a.dt_atualizacao		>= dt_suspensao_p

union all

select	a.nr_sequencia,
	a.nr_prescricao
from	rep_jejum a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.nr_atendimento		= nr_atendimento_w
and	a.dt_atualizacao		>= dt_suspensao_p

union all

select	a.nr_sequencia,
	a.nr_prescricao
from	rep_jejum a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
and	a.dt_atualizacao		>= dt_suspensao_p
and	coalesce(b.nr_atendimento::text, '') = ''
and	coalesce(nr_atendimento_w::text, '') = '';

c04 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_prescricao
from	nut_pac a,
	prescr_medica b
where	a.nr_sequencia			= nr_seq_orig_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_sequencia,
	a.nr_prescricao
from	nut_pac a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.nr_atendimento		= nr_atendimento_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_sequencia,
	a.nr_prescricao
from	nut_pac a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
and	a.dt_suspensao			>= dt_suspensao_p
and	coalesce(b.nr_atendimento::text, '') = ''
and	coalesce(nr_atendimento_w::text, '') = '';

c05 CURSOR FOR
SELECT	a.nr_prescricao,
	a.nr_seq_solucao
from	prescr_solucao a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao			= nr_prescr_orig_w
and	a.nr_seq_solucao		= nr_seq_orig_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_seq_solucao
from	prescr_solucao a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.nr_atendimento		= nr_atendimento_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_seq_solucao
from	prescr_solucao a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
and	a.dt_suspensao			>= dt_suspensao_p
and	coalesce(b.nr_atendimento::text, '') = ''
and	coalesce(nr_atendimento_w::text, '') = '';

c06 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_prescricao
from	prescr_gasoterapia a
where	a.nr_sequencia			= nr_seq_orig_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_sequencia,
	a.nr_prescricao
from	prescr_gasoterapia a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.nr_atendimento		= nr_atendimento_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_sequencia,
	a.nr_prescricao
from	prescr_gasoterapia a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
and	a.dt_suspensao			>= dt_suspensao_p
and	coalesce(b.nr_atendimento::text, '') = ''
and	coalesce(nr_atendimento_w::text, '') = '';

c07 CURSOR FOR
SELECT	a.nr_prescricao,
	a.nr_sequencia
from	prescr_procedimento a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao			= nr_prescr_orig_w
and	a.nr_sequencia			= nr_seq_orig_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_sequencia
from	prescr_procedimento a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.nr_atendimento		= nr_atendimento_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_sequencia
from	prescr_procedimento a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
and	a.dt_suspensao			>= dt_suspensao_p
and	coalesce(b.nr_atendimento::text, '') = ''
and	coalesce(nr_atendimento_w::text, '') = '';

c08 CURSOR FOR
SELECT	a.nr_prescricao,
	a.nr_sequencia
from	prescr_recomendacao a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao			= nr_prescr_orig_w
and	a.nr_sequencia			= nr_seq_orig_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_sequencia
from	prescr_recomendacao a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.nr_atendimento		= nr_atendimento_w
and	a.dt_suspensao			>= dt_suspensao_p

union all

select	a.nr_prescricao,
	a.nr_sequencia
from	prescr_recomendacao a,
	prescr_medica b
where	a.nr_prescricao			= b.nr_prescricao
and	a.nr_prescricao_original	= nr_prescr_orig_w
and	a.nr_seq_anterior		= nr_seq_orig_w
and	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
and	a.dt_suspensao			>= dt_suspensao_p
and	coalesce(b.nr_atendimento::text, '') = ''
and	coalesce(nr_atendimento_w::text, '') = '';


BEGIN

nr_prescr_orig_w	:= PLT_obter_item_orig(nr_prescricao_p, nr_sequencia_p, upper(nm_tabela_p),'P');
nr_seq_orig_w		:= PLT_obter_item_orig(nr_prescricao_p, nr_sequencia_p, upper(nm_tabela_p),'S');

select	max(cd_pessoa_fisica),
	max(nr_atendimento)
into STRICT	cd_pessoa_fisica_w,
	nr_atendimento_w
from	prescr_medica
where	nr_prescricao	= nr_prescr_orig_w;

if (upper(nm_tabela_p) = 'PRESCR_DIETA') then

	open C02;
	loop
	fetch C02 into
		nr_prescricao_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL PLT_Desfazer_suspensao_item(nr_prescricao_w, nr_sequencia_w, nm_tabela_p, dt_suspensao_p, nm_usuario_p);
		end;
	end loop;
	close C02;

elsif (upper(nm_tabela_p) = 'REP_JEJUM') then

	open C03;
	loop
	fetch C03 into
		nr_prescricao_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		CALL PLT_Desfazer_suspensao_item(nr_prescricao_w, nr_sequencia_w, nm_tabela_p, dt_suspensao_p, nm_usuario_p);
		end;
	end loop;
	close C03;

elsif (upper(nm_tabela_p) = 'NUT_PAC') then

	open C04;
	loop
	fetch C04 into
		nr_prescricao_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin
		CALL PLT_Desfazer_suspensao_item(nr_prescricao_w, nr_sequencia_w, nm_tabela_p, dt_suspensao_p, nm_usuario_p);
		end;
	end loop;
	close C04;

elsif (upper(nm_tabela_p) = 'PRESCR_SOLUCAO') then

	open C05;
	loop
	fetch C05 into
		nr_prescricao_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		CALL PLT_Desfazer_suspensao_item(nr_prescricao_w, nr_sequencia_w, nm_tabela_p, dt_suspensao_p, nm_usuario_p);
		end;
	end loop;
	close C05;

elsif (upper(nm_tabela_p) = 'PRESCR_GASOTERAPIA') then

	open C06;
	loop
	fetch C06 into
		nr_prescricao_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C06 */
		begin
		CALL PLT_Desfazer_suspensao_item(nr_prescricao_w, nr_sequencia_w, nm_tabela_p, dt_suspensao_p, nm_usuario_p);
		end;
	end loop;
	close C06;

elsif (upper(nm_tabela_p) = 'PRESCR_PROCEDIMENTO') then

	open C07;
	loop
	fetch C07 into
		nr_prescricao_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C07 */
		begin
		CALL PLT_Desfazer_suspensao_item(nr_prescricao_w, nr_sequencia_w, nm_tabela_p, dt_suspensao_p, nm_usuario_p);
		end;
	end loop;
	close C07;

elsif (upper(nm_tabela_p) = 'PRESCR_RECOMENDACAO') then

	open C08;
	loop
	fetch C08 into
		nr_prescricao_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C08 */
		begin
		CALL PLT_Desfazer_suspensao_item(nr_prescricao_w, nr_sequencia_w, nm_tabela_p, dt_suspensao_p, nm_usuario_p);
		end;
	end loop;
	close C08;

elsif (upper(nm_tabela_p) = 'PRESCR_MATERIAL') then

	open C01;
	loop
	fetch C01 into
		nr_prescricao_w,
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		CALL PLT_Desfazer_suspensao_item(nr_prescricao_w, nr_sequencia_w, nm_tabela_p, dt_suspensao_p, nm_usuario_p);
		end;
	end loop;
	close C01;

end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_desfazer_suspensao_itens ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_tabela_p text, dt_suspensao_p timestamp, nm_usuario_p text) FROM PUBLIC;

