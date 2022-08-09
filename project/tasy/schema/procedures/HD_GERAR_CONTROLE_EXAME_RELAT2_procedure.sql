-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_gerar_controle_exame_relat2 (cd_pessoa_fisica_p text, dt_parametro_p text, nr_seq_protocolo_p bigint, ds_itens_p text, nm_usuario_p text, nr_seq_escala_p bigint, nr_seq_turno_p bigint) AS $body$
DECLARE

dt_referencia_w		timestamp;
cd_pessoa_fisica_w	varchar(255);

c01 CURSOR FOR
	SELECT	cd_pessoa_fisica
	from	hd_pac_renal_cronico
	where	1 = 1
	and	hd_obter_se_pac_ativo_data(cd_pessoa_fisica,dt_referencia_w) = 'S'
	and	((coalesce(cd_pessoa_fisica_p::text, '') = '')  or (cd_pessoa_fisica = cd_pessoa_fisica_p))
	and     (( coalesce(nr_seq_escala_p::text, '') = '') or (HD_Obter_Escala_PRC(cd_pessoa_fisica, 'C') = nr_seq_escala_p))
	and     ((coalesce(nr_seq_turno_p::text, '') = '') or (HD_Obter_Turno_PRC(cd_pessoa_fisica, 'C') = nr_seq_turno_p))
	order by cd_pessoa_fisica;



BEGIN
---20011,cd_pessoa_fisica_p || '#@#@');
dt_referencia_w	:= clock_timestamp();

if (dt_parametro_p <> '  /  /    ') then
	dt_referencia_w := trunc(trunc(to_date(dt_parametro_p,'dd/mm/yyyy'),'month') - 1,'month');
end if;

open c01;
loop
fetch c01 into
	cd_pessoa_fisica_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	CALL hd_gerar_controle_exame(cd_pessoa_fisica_w,
				nr_seq_protocolo_p,
				dt_referencia_w,
				ds_itens_p,
				'N',
				1,
				nm_usuario_p);


	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_gerar_controle_exame_relat2 (cd_pessoa_fisica_p text, dt_parametro_p text, nr_seq_protocolo_p bigint, ds_itens_p text, nm_usuario_p text, nr_seq_escala_p bigint, nr_seq_turno_p bigint) FROM PUBLIC;
