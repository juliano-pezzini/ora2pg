-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_leite_derivado ( nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE


hr_prim_horario_w	varchar(5);
cd_intervalo_w		varchar(7);

BEGIN

if (nr_prescricao_p > 0) then

	select 	to_char(coalesce(max(dt_inicio_prescr),clock_timestamp()),'hh24:mi')
	into STRICT	hr_prim_horario_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	select max(cd_intervalo)
	into STRICT   cd_intervalo_w
	from   intervalo_prescricao
	WHERE  ie_situacao = 'A'
	and    ((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento))
	AND    Obter_se_intervalo(cd_intervalo, 16) = 'S'
	AND    ie_prescricao_dieta = 'C';

	if (coalesce(cd_intervalo_w,'XPTO') = 'XPTO') then
		select max(cd_intervalo)
		into STRICT   cd_intervalo_w
		from   intervalo_prescricao
		where  ie_situacao = 'A'
		and    ((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento))
		AND    Obter_se_intervalo(cd_intervalo, 16) = 'S';
	end if;

	if (coalesce(cd_intervalo_w,'XPTO') = 'XPTO') then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(250475);
	end if;

	insert into prescr_leite_deriv(
										nr_prescricao,
										nr_sequencia,
										nm_usuario,
										dt_atualizacao,
										hr_prim_horario,
										ds_horarios,
										cd_intervalo,
										ie_via_aplicacao,
										ie_se_necessario)
							values (
										nr_prescricao_p,
										nextval('prescr_leite_deriv_seq'),
										nm_usuario_p,
										clock_timestamp(),
										hr_prim_horario_w,
										hr_prim_horario_w,
										cd_intervalo_w,
										'O', -- Informado  fixo 'O' conforme conversado com Phillipe
										'N'); -- Informado  fixo 'N' conforme conversado com Phillipe
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_leite_derivado ( nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
