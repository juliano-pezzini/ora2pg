-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_perda_ganho_disp ( nr_atendimento_p bigint, nr_seq_tipo_p bigint, dt_medida_p timestamp, nm_usuario_p text, ds_consistencia_p INOUT text) AS $body$
DECLARE


ie_exige_dispositivo_w	varchar(1);
nr_seq_dispositivo_w	bigint;
ie_instalado_w		varchar(1);
qt_dispositivo_w	smallint;
ds_perda_ganho_w	varchar(50);
ie_perda_ganho_w	varchar(1);


BEGIN

select	coalesce(max(ie_exige_dispositivo),'N')
into STRICT	ie_exige_dispositivo_w
from	tipo_perda_ganho
where	nr_sequencia	=	nr_seq_tipo_p;

select	count(*)
into STRICT	qt_dispositivo_w
from	tipo_ganho_perda_disp
where	nr_seq_ganho_perda = nr_seq_tipo_p;

if (ie_exige_dispositivo_w = 'S') and (qt_dispositivo_w > 0) then
	select	coalesce(max('S'),'N')
	into STRICT	ie_instalado_w
	from	tipo_ganho_perda_disp
	where	nr_seq_ganho_perda = nr_seq_tipo_p
	and	obter_se_disp_instal_data(nr_atendimento_p, nr_seq_dispositivo, dt_medida_p) = 'S';

	if (ie_instalado_w = 'N') then

		select	substr(obter_tipo_perda_ganho(nr_seq_tipo_p,'C'),1,40)
		into STRICT	ie_perda_ganho_w
		;

		if (ie_perda_ganho_w = 'P') then
			ds_perda_ganho_w	:= Wheb_mensagem_pck.get_texto(306547); --'esta perda';
		elsif (ie_perda_ganho_w = 'G') then
			ds_perda_ganho_w	:= Wheb_mensagem_pck.get_texto(306548); --'este ganho';
		end if;

		ds_consistencia_p := Wheb_mensagem_pck.get_texto(306545, 'DS_PERDA_GANHO_W='||ds_perda_ganho_w); -- 'Não é possível registrar ' || ds_perda_ganho_w || ', pois não há dispositivos no paciente que permitam este controle.';
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_perda_ganho_disp ( nr_atendimento_p bigint, nr_seq_tipo_p bigint, dt_medida_p timestamp, nm_usuario_p text, ds_consistencia_p INOUT text) FROM PUBLIC;

