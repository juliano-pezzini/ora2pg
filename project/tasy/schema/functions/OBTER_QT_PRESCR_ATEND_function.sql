-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_prescr_atend ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w				varchar(2000);
qt_mat_w				integer;
ds_proc_w				varchar(2000);
nm_curto_w				varchar(10);
qt_item_w				bigint;
qt_amostra_w				bigint;
qt_exec_w				bigint;
ds_virgula_w				varchar(02);
qt_proc_w				bigint := 0;
dt_referencia_w				timestamp;
qt_rec_w				bigint	:= 0;
qt_dieta_w				bigint;
qt_soluc_w				bigint;
nr_prescricao_w				bigint;
nr_seq_prescricao_w			bigint;
qt_reg_w				bigint;
qt_reg_ww				bigint;
cd_procedimento_w			bigint;
ie_origem_proced_w			bigint;
qt_prescricao_w				bigint;

c01 CURSOR FOR
SELECT	coalesce(nm_curto,'Proc'),
	sum(CASE WHEN coalesce(nr_seq_exame::text, '') = '' THEN  -1  ELSE CASE WHEN coalesce(ie_amostra,'N')='S' THEN 0  ELSE 1 END  END ),
	sum(CASE WHEN b.cd_motivo_baixa=0 THEN 0  ELSE qt_procedimento END ) qt_exec,
	count(*)
FROM prescr_medica a, prescr_procedimento b
LEFT OUTER JOIN setor_atendimento c ON (b.cd_setor_atendimento = c.cd_setor_atendimento)
WHERE a.nr_prescricao		= b.nr_prescricao  and a.nr_atendimento	= nr_atendimento_p and coalesce(b.nr_seq_origem::text, '') = '' and (coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '') and b.ie_suspenso		= 'N' and a.dt_prescricao		between dt_referencia_w and clock_timestamp() + interval '2 days' group by coalesce(nm_curto,'Proc');


C02 CURSOR FOR
	SELECT	b.cd_procedimento,
		b.ie_origem_proced
	from	prescr_procedimento b,
		prescr_medica a
	where	a.nr_prescricao		= b.nr_prescricao
	and	a.nr_atendimento	= nr_atendimento_p
	and	coalesce(b.nr_seq_origem::text, '') = ''
	and	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')
	and	b.cd_motivo_baixa	= 0
	and	b.ie_suspenso		= 'N'
	and	a.dt_prescricao		between dt_referencia_w and clock_timestamp() + interval '2 days';
	--and	substr(obter_se_proc_enfermagem_pa(b.cd_procedimento,b.ie_origem_proced),1,1) = 'S';
C03 CURSOR FOR
	SELECT	b.nr_prescricao,
		b.nr_sequencia
	from	prescr_procedimento b,
		prescr_medica a
	where	a.nr_prescricao		= b.nr_prescricao
	and	a.nr_atendimento	= nr_atendimento_p
	and	coalesce(b.nr_seq_origem::text, '') = ''
	and	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')
	and	b.cd_motivo_baixa	= 0
	and	b.ie_suspenso		= 'N'
	and	b.cd_procedimento	= cd_procedimento_w
	and	b.ie_origem_proced 	= ie_origem_proced_w
	and	a.dt_prescricao		between dt_referencia_w and clock_timestamp() + interval '2 days';



BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	ds_proc_w				:= '';
	ds_virgula_w				:= '';
	dt_referencia_w				:= clock_timestamp() - interval '2 days';


	select	count(1)
	into STRICT	qt_prescricao_w
	from	prescr_medica a
	where	a.nr_atendimento	= nr_atendimento_p
	and	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '');

	if (qt_prescricao_w	> 0) then


		select count(a.nr_prescricao)
		into STRICT	qt_mat_w
		from 	prescr_material b,
			prescr_medica a
		where	a.nr_prescricao	= b.nr_prescricao
		and	a.nr_atendimento	= nr_atendimento_p
		and	b.cd_motivo_baixa	= 0
		and	a.dt_prescricao		between dt_referencia_w and clock_timestamp() + interval '2 days'
		and	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')
		and	b.ie_suspenso		= 'N';

		open c01;
		loop
		fetch c01 into
			nm_curto_w,
			qt_amostra_w,
			qt_exec_w,
			qt_item_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

			ds_proc_w		:= ds_proc_w || ds_virgula_w || qt_item_w || nm_curto_w;
			if (qt_amostra_w > -1) then
				ds_proc_w	:= ds_proc_w || '(' || qt_amostra_w || '-' || qt_exec_w ||') ';
			else
				ds_proc_w	:= ds_proc_w || '(' || qt_exec_w ||') ';
			end if;
			ds_virgula_w		:= ', ';
		end loop;
		close c01;

		open C02;
		loop
		fetch C02 into
			cd_procedimento_w,
			ie_origem_proced_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			if (obter_se_proc_enfermagem_pa(cd_procedimento_w,ie_origem_proced_w) = 'S') then

				qt_proc_w	 :=0;
				open C03;
				loop
				fetch C03 into
					nr_prescricao_w,
					nr_seq_prescricao_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					qt_proc_w	:= qt_proc_w+1;

					select	count(1)
					into STRICT	qt_reg_w
					from	prescr_proc_hor x
					where	nr_prescricao = nr_prescricao_w
					and	nr_seq_procedimento = nr_seq_prescricao_w
					and	OBTER_SE_HORARIO_LIBERADO(x.dt_lib_horario, x.dt_horario) = 'S';

					if (qt_reg_w	>0)then
						select	count(1)
						into STRICT	qt_reg_ww
						from	prescr_proc_hor x
						where	nr_prescricao = nr_prescricao_w
						and	nr_seq_procedimento = nr_seq_prescricao_w
						and	OBTER_SE_HORARIO_LIBERADO(x.dt_lib_horario, x.dt_horario) = 'S'
						and	coalesce(x.dt_suspensao::text, '') = '';

						if (qt_reg_ww	= 0) then
							qt_proc_w	:= qt_proc_w -1;
						end if;
					end if;

					end;
				end loop;
				close C03;

			end if;

			end;
		end loop;
		close C02;


		select	count(1)
		into STRICT	qt_rec_w
		from	prescr_recomendacao b,
			prescr_medica a
		where	a.nr_prescricao		= b.nr_prescricao
		and	a.nr_atendimento	= nr_atendimento_p
		and	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')
		and	b.ie_suspenso		= 'N'
		and	a.dt_prescricao		between dt_referencia_w and clock_timestamp() + interval '2 days';

		select	count(1)
		into STRICT	qt_dieta_w
		from	prescr_dieta b,
			prescr_medica a
		where	a.nr_prescricao		= b.nr_prescricao
		and	a.nr_atendimento	= nr_atendimento_p
		and	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')
		and	b.ie_suspenso		= 'N'
		and	a.dt_prescricao		between dt_referencia_w and clock_timestamp() + interval '2 days';

		select	count(1)
		into STRICT	qt_soluc_w
		from	prescr_solucao b,
			prescr_medica a
		where	a.nr_prescricao		= b.nr_prescricao
		and	a.nr_atendimento	= nr_atendimento_p
		and	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')
		and	b.ie_suspenso		= 'N'
		and	a.dt_prescricao		between dt_referencia_w and clock_timestamp() + interval '2 days';

		ds_retorno_w	:= ds_proc_w;
		if (qt_proc_w > 0) then
			ds_retorno_w	:= ds_retorno_w ||' '|| obter_desc_expressao(726412) ||'('||to_char(qt_proc_w)||')';
		end if;

		if (qt_soluc_w > 0) then
			ds_retorno_w	:= ds_retorno_w ||' '|| obter_desc_expressao(306511) ||'('||to_char(qt_soluc_w)||')';
		end if;
		if (qt_mat_w > 0) then
			ds_retorno_w	:= qt_mat_w || obter_desc_expressao(293040) || ds_virgula_w || ds_retorno_w;
		end if;
		if (qt_rec_w	> 0) then
			ds_retorno_w	:= ds_retorno_w ||' '|| obter_desc_expressao(726426) ||' ('||to_char(qt_rec_w)||')';
		end if;

		if (qt_dieta_w	> 0) then
			ds_retorno_w	:= ds_retorno_w ||' '|| obter_desc_expressao(726428) ||' ('||to_char(qt_dieta_w)||')';
		end if;

	end if;

end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_prescr_atend ( nr_atendimento_p bigint) FROM PUBLIC;
