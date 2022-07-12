-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_filtro_regra_event_cta_pck.gera_evento_default ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_evento_w 	integer;


BEGIN
-- verifica se existe o evento de sequencia '-1' na base

select	count(1)
into STRICT	qt_evento_w
from	pls_evento
where	nr_sequencia = -1;

-- se nao existe cria este evento

if (qt_evento_w = 0) then
	insert into pls_evento(nr_sequencia,
				ds_evento,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				ie_situacao,
				ie_natureza,
				ie_tipo_evento,
				ie_saldo_negativo)
			values (	-1,
				'Evento para manter integridade referencial e performance',
				cd_estabelecimento_p,
				clock_timestamp(),
				nm_usuario_p,
				'I',
				'D',
				'F',
				'CP');
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_filtro_regra_event_cta_pck.gera_evento_default ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;