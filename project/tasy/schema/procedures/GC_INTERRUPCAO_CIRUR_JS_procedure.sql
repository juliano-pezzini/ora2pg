-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gc_interrupcao_cirur_js ( nr_cirurgia_p bigint, nr_seq_interrupcao_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) AS $body$
DECLARE


ie_saida_setor_inter_w varchar(1);


BEGIN

if (nr_seq_interrupcao_p IS NOT NULL AND nr_seq_interrupcao_p::text <> '') and (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then
	begin

	ie_saida_setor_inter_w := obter_param_usuario(900, 151, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_saida_setor_inter_w);

	CALL gravar_interrupcao_cirurgia(nr_seq_interrupcao_p,nr_cirurgia_p,nm_usuario_p);

	if (ie_saida_setor_inter_w = 'S') then
		begin
		CALL registrar_saida_setor_cirur(nr_cirurgia_p,nm_usuario_p,ie_acao_p);
		end;
	end if;

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gc_interrupcao_cirur_js ( nr_cirurgia_p bigint, nr_seq_interrupcao_p bigint, ie_acao_p text, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;

