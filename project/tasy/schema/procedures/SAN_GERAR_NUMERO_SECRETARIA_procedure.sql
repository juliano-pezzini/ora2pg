-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_gerar_numero_secretaria ( nr_seq_doacao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text) AS $body$
DECLARE


nr_seq_regra_w		bigint;
qt_minimo_w		bigint;
qt_maximo_w		bigint;
nr_sec_saude_w		varchar(20);
qt_sec_saude_aviso_w	bigint;


BEGIN
ds_mensagem_p := '';

select	max(nr_sequencia)
into STRICT	nr_seq_regra_w
from	san_regra_secretaria
where	cd_estabelecimento = cd_estabelecimento_p
and	ie_situacao = 'A'
and	clock_timestamp() between dt_vigencia_ini and fim_dia(dt_vigencia_fim);

if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then

	select	max(qt_minimo),
		max(qt_maximo),
		max(nr_seq_sec_atual) + 1
	into STRICT	qt_minimo_w,
		qt_maximo_w,
		nr_sec_saude_w
	from	san_regra_secretaria
	where	nr_sequencia = nr_seq_regra_w;

	if (nr_sec_saude_w < qt_minimo_w) then
		nr_sec_saude_w := qt_minimo_w;
	end if;

	if (nr_sec_saude_w > qt_maximo_w) then
		ds_mensagem_p := wheb_mensagem_pck.get_texto(309620); -- A numeração da secretaria de saúde definida na regra chegou ao fim!
	end if;

	if (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') and (coalesce(ds_mensagem_p::text, '') = '') then

		update	san_doacao
		set	nr_sec_saude = nr_sec_saude_w
		where	nr_sequencia = nr_seq_doacao_p;

		update	san_regra_secretaria
		set	nr_seq_sec_atual = nr_sec_saude_w
		where	nr_sequencia = nr_seq_regra_w;

		qt_sec_saude_aviso_w := obter_param_usuario(450, 280, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_sec_saude_aviso_w);

		if (qt_sec_saude_aviso_w <> 0) and ((qt_maximo_w - nr_sec_saude_w) <= qt_sec_saude_aviso_w) then
			ds_mensagem_p := wheb_mensagem_pck.get_texto(309621); -- A quantidade de números da secretária de saúde definida na regra está terminando! Favor verificar.
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_gerar_numero_secretaria ( nr_seq_doacao_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text) FROM PUBLIC;

