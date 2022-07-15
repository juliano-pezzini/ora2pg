-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_ci_suspensao_prescricao (nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE

--- Declaração das variáveis
nr_seq_regra_w		bigint;
ds_titulo_w		varchar(255);
ds_mensagem_w		varchar(2000);
cd_perfil_w		bigint;
cd_perfil_destino_w	varchar(2000);
nr_seq_classif_w	bigint;
nr_seq_comunic_w	bigint;
ie_tipo_Atendimento_w	bigint;
--- Cursor que busca as mensagens e os titulos
c01 CURSOR FOR
SELECT	nr_sequencia,
	ds_titulo,
	ds_mensagem
from 	rep_ci_suspensao
where	coalesce(ie_tipo_Atendimento,ie_tipo_Atendimento_w)	= ie_tipo_Atendimento_w
order by
	1;
--- Cursor que busca os perfis que irão receber a mensagem
c02 CURSOR FOR
SELECT	cd_perfil
from	rep_ci_suspensao_perfil
where 	nr_seq_regra = nr_seq_regra_w
order by
	1;


BEGIN
--- Busca a sequencia da classificação da CI
select	max(nr_sequencia)
into STRICT	nr_seq_classif_w
from	comunic_interna_classif
where	ie_tipo	= 'F'
and 	ie_situacao = 'A';

select	max(obter_tipo_atendimento(nr_atendimento))
into STRICT	ie_tipo_Atendimento_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;
--- Inicia o cursor de busca do titulo e da mensagem da CI
open c01;
loop
fetch c01 into
	nr_seq_regra_w,
	ds_titulo_w,
	ds_mensagem_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	--- Inicia o cursor de busca dos perfis que irão receber a mensagem
	open c02;
	loop
	fetch c02 into
		cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		--- Verifica se a variavel de perfis de destino não é nula e adiciona uma virgula para separar o
		if (cd_perfil_destino_w IS NOT NULL AND cd_perfil_destino_w::text <> '') or (cd_perfil_destino_w <> '') and (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '')then
			cd_perfil_destino_w := cd_perfil_destino_w || ',';
		end if;
		--- Adiciona o perfil que retornou no  cursor
		cd_perfil_destino_w := substr(cd_perfil_destino_w || cd_perfil_w,1,1000);
		end;
	end loop;
	close c02;
	--- V erifica se a mensagem não é null e pula uma linha.
	if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '') or (ds_mensagem_w <> '') then
		ds_mensagem_w := ds_mensagem_w||chr(13);
	end if;
	--- Adiciona o número da prescrição na mensagem
	ds_mensagem_w := ds_mensagem_w || ' ' || obter_desc_expressao(493955) || ': ' || nr_prescricao_p;
	--- Verifica se o titulo não é nulo
	if (ds_titulo_w IS NOT NULL AND ds_titulo_w::text <> '') and (cd_perfil_destino_w IS NOT NULL AND cd_perfil_destino_w::text <> '')then
			--- Busca a próxima sequencia na tabela
			select	nextval('comunic_interna_seq')
			into STRICT	nr_seq_comunic_w
			;
			insert	into comunic_interna(
				dt_comunicado,
				ds_titulo,
				ds_comunicado,
				nm_usuario,
				nm_usuario_destino,
				dt_atualizacao,
				ie_geral,
				ie_gerencial,
				ds_perfil_adicional,
				nr_sequencia,
				nr_seq_classif,
				dt_liberacao)
			values (
				clock_timestamp(),
				ds_titulo_w,
				ds_mensagem_w,
				nm_usuario_p,
				null,
				clock_timestamp(),
				'N',
				'N',
				cd_perfil_destino_w,
				nr_seq_comunic_w,
				nr_seq_classif_w,
				clock_timestamp());
			if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	end if;
	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_ci_suspensao_prescricao (nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;

