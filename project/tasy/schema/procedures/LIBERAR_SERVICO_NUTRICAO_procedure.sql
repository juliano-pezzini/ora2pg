-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_servico_nutricao ( nr_seq_nut_serv_p bigint, nm_usuario_p text, ie_acao_p text) AS $body$
DECLARE

Ie_Status_ADEP_w	      varchar(1);
nr_atendimento_w	      bigint;
nr_seq_serv_acompanhante_w    bigint;
nr_atendimento_acompanhante_w bigint;
ie_tem_jejum_w			varchar(1);

c1 CURSOR FOR
SELECT	nr_seq_atend_serv_dia
from 	nut_atend_acompanhante
where 	nr_seq_atend_serv_dia = nr_seq_nut_serv_p;
	

BEGIN

if (nr_seq_nut_serv_p IS NOT NULL AND nr_seq_nut_serv_p::text <> '') then

	if (ie_acao_p = 'L') then
	
		select	substr(nut_obter_se_tem_jejum(nr_sequencia), 1, 1)
		into STRICT	ie_tem_jejum_w
		from	nut_atend_serv_dia
		where	nr_sequencia = nr_seq_nut_serv_p;

			CALL inserir_historico_serv_nut(nm_usuario_p, nr_seq_nut_serv_p, 'LS');
			
			/* Gerar lancamento automatico - Inicio */

			select	coalesce(max(nr_atendimento),0)
			into STRICT	nr_atendimento_w
			from	nut_atend_serv_dia
			where	nr_sequencia = nr_seq_nut_serv_p;
			
			if (ie_tem_jejum_w = 'N') then
				update  nut_atend_serv_dia
				set	dt_liberacao = clock_timestamp(),
				nm_usuario_lib = nm_usuario_p,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp(),
				ie_status_adep = 'N'
				where	nr_sequencia = nr_seq_nut_serv_p;
				if (nr_atendimento_w > 0) then	
					CALL gerar_lancamento_automatico(nr_atendimento_w, null, 590, nm_usuario_p, null, nr_seq_nut_serv_p, 'P', null, null, null);
				end if;
			end if;
			
			open c1;
			loop
			fetch c1 into
			    nr_seq_serv_acompanhante_w;
			EXIT WHEN NOT FOUND; /* apply on c1 */
			     begin		
				if (nr_atendimento_w > 0 and
				nr_seq_serv_acompanhante_w > 0) then	
					CALL gerar_lancamento_automatico(nr_atendimento_w, null, 590, nm_usuario_p, null, nr_seq_serv_acompanhante_w, 'A', null, null, null);
					update  nut_atend_serv_dia
					set	dt_lib_servico_acomp = clock_timestamp(),
					nm_usu_lib_serv_acomp = nm_usuario_p,
					nm_usuario = nm_usuario_p,
					dt_atualizacao = clock_timestamp(),
					ie_status_adep = 'N'
					where	nr_sequencia = nr_seq_nut_serv_p;
				end if;	
			     end;
			end loop;
			close c1;
			/* Gerar lancamento automatico - Fim */

	else
		Select	coalesce(max(Ie_Status_ADEP),'Y')
		into STRICT	Ie_Status_ADEP_w
		from	nut_atend_serv_dia
		where	nr_sequencia = nr_seq_nut_serv_p;
		
		if (Ie_Status_ADEP_w in ('Y', 'N')) then
			update  nut_atend_serv_dia
			set	dt_liberacao  = NULL,
				nm_usuario_lib  = NULL,
        nm_usu_lib_serv_acomp  = NULL,
        dt_lib_servico_acomp  = NULL,
				nm_usuario = nm_usuario_p,
				dt_atualizacao = clock_timestamp(),
				ie_status_adep = 'Y'
			where	nr_sequencia = nr_seq_nut_serv_p
			and	coalesce(dt_atend_servico::text, '') = '';
			
			CALL inserir_historico_serv_nut(nm_usuario_p, nr_seq_nut_serv_p, 'DLS');
		elsif (Ie_Status_ADEP_w = 'A' and wheb_usuario_pck.get_cd_funcao != 2314) then
			-- Nao e possivel reverter a liberacao pois o servico ja foi administrado pelo ADEP!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(225116);
		elsif (Ie_Status_ADEP_w = 'S' and wheb_usuario_pck.get_cd_funcao != 2314) then
			-- Nao e possivel reverter a liberacao pois o servico foi suspenso pelo ADEP!
			CALL wheb_mensagem_pck.exibir_mensagem_abort(225117);
		end if;
	end if;
	
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_servico_nutricao ( nr_seq_nut_serv_p bigint, nm_usuario_p text, ie_acao_p text) FROM PUBLIC;

