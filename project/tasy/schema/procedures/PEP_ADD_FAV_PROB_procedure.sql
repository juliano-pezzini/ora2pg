-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_add_fav_prob ( nr_sequencia_p text, nm_usuario_p text, nr_atendimento_p bigint) AS $body$
DECLARE


nr_sequencia_ww		varchar(4000);
nr_sequencia_w		proc_pac_descricao.nr_sequencia%type;
item_w			    pep_fav_problema.nr_sequencia%type;

BEGIN

nr_sequencia_ww := nr_sequencia_p;

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from	lista_problema_pac;

for i in 1..length(nr_sequencia_ww) loop

	if (length(nr_sequencia_ww) > 0) then
		
		item_w := substr(nr_sequencia_ww, 1, position(',' in nr_sequencia_ww) - 1);
		nr_sequencia_ww := substr(nr_sequencia_ww, position(',' in nr_sequencia_ww) + 1, length(nr_sequencia_ww));
		
		if	(item_w IS NOT NULL AND item_w::text <> '' AND nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

			nr_sequencia_w := nr_sequencia_w + 1;

			insert	into lista_problema_pac(nr_sequencia,
							dt_atualizacao,
							dt_inicio,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							cd_doenca,
							ds_problema,
							ie_tipo_diagnostico,
							nr_seq_cad_problema,
							nr_seq_categoria,
							nr_seq_historico,
							nr_seq_tipo_hist,
							cd_pessoa_fisica,
							nr_atendimento,
							ie_situacao)
						(SELECT	nr_sequencia_w,
							clock_timestamp(),
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							cd_doenca,
							ds_problema,
							ie_tipo_diagnostico,
							nr_seq_cad_problema,
							nr_seq_categoria,
							nr_seq_historico,
							nr_seq_tipo_hist,
							substr(obter_pessoa_atendimento(nr_atendimento_p,'C'),1,10),
							nr_atendimento_p,
							'A'
						from	pep_fav_problema
						where	nm_usuario = nm_usuario_p
						and	nr_sequencia = item_w);
		end if;

	end if;

end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_add_fav_prob ( nr_sequencia_p text, nm_usuario_p text, nr_atendimento_p bigint) FROM PUBLIC;
