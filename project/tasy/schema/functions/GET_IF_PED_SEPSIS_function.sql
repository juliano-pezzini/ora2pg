-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_if_ped_sepsis ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_estabelecimento_w        smallint;
ie_finaliza_manual_w        varchar(1);
qt_reg_sepsis_w             bigint := 0;
dt_alta_w                   timestamp;
qt_horas_sepsis_w           bigint;
existe_liberacao_sepsis_w   varchar(1);
ie_sepse_ped				varchar(1) := 'N';


BEGIN
	if (coalesce(nr_atendimento_p,0) > 0) then

		Select 	max(dt_alta)
		into STRICT	dt_alta_w
		from	atendimento_paciente
		where	nr_atendimento = nr_atendimento_p;
		
		if (coalesce(dt_alta_w::text, '') = '') then		
				
				select obter_dados_atendimento(nr_atendimento_p,'EST'),
					   obter_se_sepse_liberada(nr_atendimento_p)
				into STRICT   cd_estabelecimento_w,
					   existe_liberacao_sepsis_w
				;

			if (existe_liberacao_sepsis_w <> 'N' ) then

				Select  max(QT_HORAS_SEPSIS)
				into STRICT	qt_horas_sepsis_w
				from 	parametro_medico
				where	cd_estabelecimento = cd_estabelecimento_w;			

				--- SEPSE PEDIATRICA
				if (existe_liberacao_sepsis_w = 'P') then
				
					ie_finaliza_manual_w := obter_se_sepse_liberada(nr_atendimento_p, 'F');
					
					if (ie_finaliza_manual_w = 'S') then
						Select  count(*)
						into STRICT	qt_reg_sepsis_w
						from	escala_sepse_infantil
						where 	nr_atendimento = nr_atendimento_p
						and     coalesce(dt_fim_protocolo::text, '') = ''
						and	    coalesce(ie_situacao,'A') = 'A'
						and     (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
						
					elsif (coalesce(qt_horas_sepsis_w,0) > 0) then
					
						Select  count(*)
						into STRICT	qt_reg_sepsis_w
						from	escala_sepse_infantil
						where 	nr_atendimento = nr_atendimento_p
						and	dt_atualizacao_nrec between (clock_timestamp()  - (1/24 * qt_horas_sepsis_w)) and clock_timestamp()
						and	coalesce(ie_situacao,'A') = 'A'
						and     (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
						
					end if;
					
					if (qt_reg_sepsis_w > 0) then
						ie_sepse_ped := 'S';					
					end if;
					
				end if;
			end if;
		else
			ie_sepse_ped := 'S';
		end if;
	end if;
	return ie_sepse_ped;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_if_ped_sepsis ( nr_atendimento_p bigint) FROM PUBLIC;
