-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_hist_evento_atend ( nr_seq_atendimento_p bigint, nr_seq_tipo_hist_p bigint, ds_historico_p text, nm_usuario_p text, cd_estabelecimento_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gravar o histórico de evento do atendimento
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_atend_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_atend_w
from	pls_atendimento
where	coalesce(dt_fim_atendimento::text, '') = ''
and	nr_sequencia = nr_seq_atendimento_p;

if (qt_atend_w > 0) and (coalesce(ds_historico_p,'X') <> 'X') then

	insert	into	pls_atendimento_historico( nr_sequencia, nr_seq_atendimento, ds_historico_long,
		 dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		 nm_usuario_nrec, nr_seq_tipo_historico, dt_historico,
		 ie_gerado_sistema)
	values (nextval('pls_atendimento_historico_seq'), nr_seq_atendimento_p, ds_historico_p,
		 clock_timestamp(), nm_usuario_p, clock_timestamp(),
		 nm_usuario_p, nr_seq_tipo_hist_p, clock_timestamp(),
		 'N');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_hist_evento_atend ( nr_seq_atendimento_p bigint, nr_seq_tipo_hist_p bigint, ds_historico_p text, nm_usuario_p text, cd_estabelecimento_p text) FROM PUBLIC;
