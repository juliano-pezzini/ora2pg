-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_clinica_regra ( nr_atendimento_p bigint, cd_pessoa_fisica_p text) AS $body$
DECLARE


nr_seq_regra_w			bigint;
cd_clinica_w			bigint;
nr_seq_proc_interno_w	bigint;
ie_possui_cirurgia_w	varchar(1);
idade_min_w				double precision;
idade_max_w				double precision;
ie_tipo_exclusivo_w		varchar(1);
cd_setor_atendimento_w	integer;

ie_regra_w				varchar(1);
cd_clinica_ficha_w		bigint;

qt_reg_w				bigint;
qt_idade_w				bigint;
nr_cih_ficha_ocorrencia_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
			cd_clinica
	from	cih_regra_atual_clinica
	where	ie_situacao = 'A'
	order by ie_prioridade desc;

C02 CURSOR FOR
	SELECT	nr_seq_proc_interno,
			ie_possui_cirurgia,
			idade_min,
			idade_max,
			ie_tipo_exclusivo,
			cd_setor_atendimento
	from	cih_regra_clinica_item
	where	nr_seq_regra = nr_seq_regra_w;


BEGIN

/*
select	max(cd_pessoa_fisica)
into	cd_pessoa_fisica_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p;
*/
select	obter_idade_pf(cd_pessoa_fisica_p,clock_timestamp(),'A')
into STRICT	qt_idade_w
;

open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	cd_clinica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ie_regra_w := 'S';

	open C02;
	loop
	fetch C02 into
		nr_seq_proc_interno_w,
		ie_possui_cirurgia_w,
		idade_min_w,
		idade_max_w,
		ie_tipo_exclusivo_w,
		cd_setor_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select 	count(*)
		into STRICT	qt_reg_w
		from	atend_paciente_unidade
		where	nr_atendimento 			= 	nr_atendimento_p
		and		cd_setor_atendimento	=	cd_setor_atendimento_w;

		if (qt_reg_w > 0) then

			if (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') then

				select 	count(*)
				into STRICT	qt_reg_w
				from	prescr_medica m,
						prescr_procedimento p,
						proc_interno i
				where	m.nr_atendimento = nr_atendimento_p
				and		m.nr_prescricao	= p.nr_prescricao
				and		p.cd_procedimento	= i.cd_procedimento
				and		p.ie_origem_proced	= i.ie_origem_proced
				and		i.nr_sequencia		= nr_seq_proc_interno_w;

				if	(qt_reg_w > 0 AND ie_tipo_exclusivo_w = 'S') then
					ie_regra_w := 'N';
				elsif	(qt_reg_w <= 0 AND ie_tipo_exclusivo_w = 'N') then
					ie_regra_w := 'N';
				end if;

			end if;

			if 	(idade_min_w IS NOT NULL AND idade_min_w::text <> '' AND qt_idade_w <= idade_min_w)	then
				ie_regra_w := 'N';
			end if;


			if 	(idade_max_w IS NOT NULL AND idade_max_w::text <> '' AND qt_idade_w >= idade_max_w)	then
				ie_regra_w := 'N';
			end if;


			if (ie_possui_cirurgia_w <> 'I') then

				select 	count(*)
				into STRICT	qt_reg_w
				from	cirurgia
				where	nr_atendimento 			= nr_atendimento_p;

				if	(qt_reg_w > 0 AND ie_possui_cirurgia_w = 'N') then
					ie_regra_w := 'N';
				elsif (qt_reg_w <= 0 AND ie_possui_cirurgia_w = 'S') then
					ie_regra_w := 'N';
				end if;


			end if;

		else
			ie_regra_w := 'N';
		end if;

		end;
	end loop;
	close C02;


	if (ie_regra_w = 'S') then
		begin
		cd_clinica_ficha_w := cd_clinica_w;
		end;
	end if;

	end;
end loop;
close C01;


if (cd_clinica_ficha_w IS NOT NULL AND cd_clinica_ficha_w::text <> '') then

	select	obter_ult_ficha_ocorrencia(nr_atendimento_p)
	into STRICT	nr_cih_ficha_ocorrencia_w
	;

	update 	cih_ficha_ocorrencia
	set		cd_clinica	= cd_clinica_ficha_w
	where	nr_ficha_ocorrencia = nr_cih_ficha_ocorrencia_w;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_clinica_regra ( nr_atendimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
