-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE oft_insere_conduta ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, vListaConduta strRecTypeFormOft) AS $body$
DECLARE


nr_sequencia_w						oft_conduta.nr_sequencia%type;
dt_exame_w							oft_conduta.dt_registro%type;
ds_conduta_w						oft_conduta.ds_conduta%type;
qt_periodo_w 						oft_conduta.qt_periodo%type;
ie_periodo_w						oft_conduta.ie_periodo%type;
ds_inf_pre_cirurgica_w			    oft_conduta.ds_inf_pre_cirurgica%type;
cd_profissional_w					oft_conduta.cd_profissional%type;	
ds_observacao_w					    oft_conduta.ds_observacao%type;
cd_destino_pac_w                    oft_conduta.cd_destino_pac%type;	
nm_usuario_w						usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;
ie_registrado_w					    varchar(1) := 'N';
ds_erro_w							varchar(4000);
											
BEGIN
begin

if (coalesce(nr_seq_consulta_p,0) > 0) and (vListaConduta.count > 0) then
	for i in 1..vListaConduta.count loop
		begin
		if (vListaConduta[i](.ds_valor IS NOT NULL AND .ds_valor::text <> '')) or (vListaConduta[i](.nr_valor IS NOT NULL AND .nr_valor::text <> '')) then
			case upper(vListaConduta[i].nm_campo)
				when 'CD_PROFISSIONAL' then
					cd_profissional_w						:= vListaConduta[i].ds_valor;
				when 'DT_REGISTRO' then
					dt_exame_w 								:= pkg_date_utils.get_DateTime(vListaConduta[i].ds_valor);
				when 'DS_CONDUTA' then
					ds_conduta_w 							:= vListaConduta[i].ds_valor;		
					ie_registrado_w						:= 'S';	
				when 'QT_PERIODO' then
					qt_periodo_w 							:= vListaConduta[i].nr_valor;
					ie_registrado_w						:= 'S';
				when 'IE_PERIODO' then
					ie_periodo_w 							:= vListaConduta[i].ds_valor;										
					ie_registrado_w						:= 'S';
				when 'DS_INF_PRE_CIRURGICA' then
					ds_inf_pre_cirurgica_w 				:= vListaConduta[i].ds_valor;		
					ie_registrado_w						:= 'S';
				when 'DS_OBSERVACAO' then
					ds_observacao_w 						:= vListaConduta[i].ds_valor;		
					ie_registrado_w						:= 'S';	
				when 'CD_DESTINO_PAC' then
                    cd_destino_pac_w := vListaConduta[i].nr_valor;
                    ie_registrado_w := 'S';
				else
					null;	
			end case;	
		end if;	
	end;
	end loop;
	
	select	max(nr_sequencia)
	into STRICT		nr_sequencia_w
	from		oft_conduta
	where		nr_seq_consulta_form = nr_seq_consulta_form_p
	and		nr_seq_consulta		= nr_seq_consulta_p
	and		coalesce(dt_liberacao::text, '') = ''
	and		nm_usuario				= nm_usuario_w;
	
	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		update	oft_conduta
		set		dt_atualizacao			=	clock_timestamp(),
					nm_usuario				=	nm_usuario_w,
					cd_profissional		= coalesce(cd_profissional_w,cd_profissional),	
					dt_registro				=	coalesce(dt_exame_w,dt_registro),
					ds_conduta				=	ds_conduta_w,
					qt_periodo				=	qt_periodo_w,
					ie_periodo				=	ie_periodo_w,
					ds_inf_pre_cirurgica = 	ds_inf_pre_cirurgica_w,
					ds_observacao			=	ds_observacao_w,
					cd_destino_pac          = cd_destino_pac_w
		where		nr_sequencia			= 	nr_sequencia_w;		
		CALL wheb_usuario_pck.set_ie_commit('S');
	else
		if (ie_registrado_w = 'S') then
			CALL wheb_usuario_pck.set_ie_commit('S');
			select	nextval('oft_conduta_seq')
			into STRICT		nr_sequencia_w	
			;

			insert	into oft_conduta(	nr_sequencia,
													dt_atualizacao, 
													nm_usuario, 
													dt_atualizacao_nrec, 
													nm_usuario_nrec, 
													cd_profissional, 
													dt_registro,
													nr_seq_consulta,
													ds_conduta, 
													qt_periodo, 
													ie_periodo, 
													ds_inf_pre_cirurgica, 
													ie_situacao,
													ds_observacao,
													nr_seq_consulta_form,
													cd_destino_pac)
			values (	nr_sequencia_w, 
													clock_timestamp(), 
													nm_usuario_w, 
													clock_timestamp(), 
													nm_usuario_w, 
													coalesce(cd_profissional_w,obter_pf_usuario(nm_usuario_w,'C')), 
													coalesce(dt_exame_w,clock_timestamp()), 
													nr_seq_consulta_p,
													ds_conduta_w, 
													qt_periodo_w, 
													ie_periodo_w, 
													ds_inf_pre_cirurgica_w, 
													'A',
													ds_observacao_w,
													nr_seq_consulta_form_p,
													cd_destino_pac_w);
		end if;											
	end if;											
end if;	

exception
when others then
	ds_erro_w	:= substr(sqlerrm,1,4000);
	update	OFT_CONSULTA_FORMULARIO
	set		ds_stack			=	substr(dbms_utility.format_call_stack||ds_erro_w,1,4000)
	where		nr_sequencia	= 	nr_seq_consulta_form_p;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE oft_insere_conduta ( nr_seq_consulta_p bigint, nr_seq_consulta_form_p bigint, vListaConduta strRecTypeFormOft) FROM PUBLIC;
