-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_macro_clob (ie_origem_p text) RETURNS text AS $body$
DECLARE

ds_retorno_w	text;
ie_utiliza_formatacao_w		varchar(1)	:= 'N';


BEGIN
ie_utiliza_formatacao_w := Obter_Param_Usuario(869, 91, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_utiliza_formatacao_w);

if (coalesce(ie_origem_p, 'AI') = 'AI') then

	if (ie_utiliza_formatacao_w = 'S') then
		begin

		ds_retorno_w	:=
			replace(obter_desc_expressao(891631), '#@macro#@', obter_desc_expressao(486585) || 
			' ' ||  obter_desc_expressao(312342)  || 
			' ' ||  obter_desc_expressao(486586)) ||CHR(10)||
			replace(obter_desc_expressao(349611), '@paciente', obter_traducao_macro_pront('@paciente',869)) ||CHR(10)||
			replace(obter_desc_expressao(642259), '@convenio', obter_traducao_macro_pront('@convenio',869)) ||CHR(10)||
			replace(obter_desc_expressao(642260), '@nascimento', obter_traducao_macro_pront('@nascimento',869)) ||CHR(10)||
			replace(obter_desc_expressao(642261), '@categoria', obter_traducao_macro_pront('@categoria',869)) ||CHR(10)||
			replace(obter_desc_expressao(642262), '@plano', obter_traducao_macro_pront('@plano',869)) ||CHR(10)||
			replace(obter_desc_expressao(642263), '@telefone', obter_traducao_macro_pront('@telefone',869)) ||CHR(10)||
			replace(obter_desc_expressao(642275), '@observacao', obter_traducao_macro_pront('@observacao',869)) ||CHR(10)||
			replace(obter_desc_expressao(642290), '@usuario', obter_traducao_macro_pront('@usuario',869)) ||CHR(10)||
			replace(obter_desc_expressao(642291), '@senha', obter_traducao_macro_pront('@senha',869)) ||CHR(10)||
			replace(obter_desc_expressao(642295), '@protocoloagenda', obter_traducao_macro_pront('@protocoloagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642308), '@dtentrega', obter_traducao_macro_pront('@dtentrega',869)) ||CHR(10)||
			replace(obter_desc_expressao(642309), '@formaentrega', obter_traducao_macro_pront('@formaentrega',869)) ||CHR(10)||
			replace(obter_desc_expressao(642310), '@maiorjejum', obter_traducao_macro_pront('@maiorjejum',869)) ||CHR(10)||
			replace(obter_desc_expressao(1064547),'@menordtchegada', obter_traducao_macro_pront('@menordtchegada',869)) ||CHR(10)||
			replace(obter_desc_expressao(788706), '@ds_end_estab_logado', obter_traducao_macro_pront('@ds_end_estab_logado',869)) ||CHR(10)||
			replace(obter_desc_expressao(788704), '@ds_estab_logado', obter_traducao_macro_pront('@ds_estab_logado',869)) ||CHR(10)||
			replace(obter_desc_expressao(642302), '@orientlab', obter_traducao_macro_pront('@orientlab',869)) ||CHR(10)||
            replace(obter_desc_expressao(1036698), '@inicioAgendamento', obter_traducao_macro_pront('@inicioAgendamento',869)) ||CHR(10)||
			replace(obter_desc_expressao(1068520), '@valorexamelab', obter_traducao_macro_pront('@valorexamelab',869)) ||CHR(10)||
			'' ||CHR(10)||
			--Macros disponiveis somente para o Cabecalho
			replace(obter_desc_expressao(891631), '#@macro#@', obter_desc_expressao(486585)) ||CHR(10)||
			replace(obter_desc_expressao(642281), '@checklist', obter_traducao_macro_pront('@checklist',869)) ||CHR(10)||
			'' ||CHR(10)||
			--Macros disponiveis somente para o item
			replace(obter_desc_expressao(891631), '#@macro#@', obter_desc_expressao(292266)) ||CHR(10)||
			replace(obter_desc_expressao(642263), '@telefone', obter_traducao_macro_pront('@telefone',869)) ||CHR(10)||
			replace(obter_desc_expressao(642264), '@agenda', obter_traducao_macro_pront('@agenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642265), '@horario', obter_traducao_macro_pront('@horario',869)) ||CHR(10)||
			replace(obter_desc_expressao(642266), '@orientpac', obter_traducao_macro_pront('@orientpac',869)) ||CHR(10)||
			replace(obter_desc_expressao(642267), '@orientexame', obter_traducao_macro_pront('@orientexame',869)) ||CHR(10)||
			replace(obter_desc_expressao(642268), '@orientanestesia', obter_traducao_macro_pront('@orientanestesia',869)) ||CHR(10)||
			replace(obter_desc_expressao(642269), '@item', obter_traducao_macro_pront('@item',869)) ||CHR(10)||
			replace(obter_desc_expressao(642270), '@regra', obter_traducao_macro_pront('@regra',869)) ||CHR(10)||
			replace(obter_desc_expressao(642271), '@glosa', obter_traducao_macro_pront('@glosa',869)) ||CHR(10)||
			replace(obter_desc_expressao(642272), '@dtprevista', obter_traducao_macro_pront('@dtprevista',869)) ||CHR(10)||
			replace(obter_desc_expressao(642273), '@dtchegada', obter_traducao_macro_pront('@dtchegada',869)) ||CHR(10)||
			replace(obter_desc_expressao(642274), '@medico', obter_traducao_macro_pront('@medico',869)) ||CHR(10)||
			replace(obter_desc_expressao(642277), '@obsagenda', obter_traducao_macro_pront('@obsagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642278), '@textopadraosetor', obter_traducao_macro_pront('@textopadraosetor',869)) ||CHR(10)||
			replace(obter_desc_expressao(642279), '@exameadicional', obter_traducao_macro_pront('@exameadicional',869)) ||CHR(10)||
			replace(obter_desc_expressao(736464), '@orientacaocomexameadic', obter_traducao_macro_pront('@orientacaocomexameadic',869)) ||CHR(10)||
			replace(obter_desc_expressao(642280), '@textopadraoexame', obter_traducao_macro_pront('@textopadraoexame',869)) ||CHR(10)||
			replace(obter_desc_expressao(642282), '@reserva', obter_traducao_macro_pront('@reserva',869)) ||CHR(10)||
			replace(obter_desc_expressao(642283), '@textopriexame', obter_traducao_macro_pront('@textopriexame',869)) ||CHR(10)||
			replace(obter_desc_expressao(642284), '@orientpreparo', obter_traducao_macro_pront('@orientpreparo',869)) ||CHR(10)||
			replace(obter_desc_expressao(642285), '@medreq', obter_traducao_macro_pront('@medreq',869)) ||CHR(10)||
			replace(obter_desc_expressao(642286), '@msgencaixe', obter_traducao_macro_pront('@msgencaixe',869)) ||CHR(10)||
			replace(obter_desc_expressao(642288), '@quimio', obter_traducao_macro_pront('@quimio',869)) ||CHR(10)||
			replace(obter_desc_expressao(642289), '@lado', obter_traducao_macro_pront('@lado',869)) ||CHR(10)||
			replace(obter_desc_expressao(642290), '@usuario', obter_traducao_macro_pront('@usuario',869)) ||CHR(10)||
			replace(obter_desc_expressao(642291), '@senha', obter_traducao_macro_pront('@senha',869)) ||CHR(10)||
			replace(obter_desc_expressao(642292), '@sala', obter_traducao_macro_pront('@sala',869)) ||CHR(10)||
			replace(obter_desc_expressao(642293), '@diasemana', obter_traducao_macro_pront('@diasemana',869)) ||CHR(10)||
			replace(obter_desc_expressao(642294), '@tipoagenda', obter_traducao_macro_pront('@tipoagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642295), '@protocoloagenda', obter_traducao_macro_pront('@protocoloagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642296), '@dtagenda', obter_traducao_macro_pront('@dtagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642297), '@FormatacaoObsPrescr', obter_traducao_macro_pront('@FormatacaoObsPrescr',869)) ||CHR(10)||
			replace(obter_desc_expressao(890033), '@FormatObsPrescrEstabAge', obter_traducao_macro_pront('@FormatObsPrescrEstabAge',869)) ||CHR(10)||
			replace(obter_desc_expressao(642298), '@FormatacaoOrientPac', obter_traducao_macro_pront('@FormatacaoOrientPac',869)) ||CHR(10)||
			replace(obter_desc_expressao(890035), '@FormatOrientPacEstabAge', obter_traducao_macro_pront('@FormatOrientPacEstabAge',869)) ||CHR(10)||
			replace(obter_desc_expressao(642299), '@FormatacaoOrientPre', obter_traducao_macro_pront('@FormatacaoOrientPre',869)) ||CHR(10)||
			replace(obter_desc_expressao(890037), '@FormatOrientPreEstabAge', obter_traducao_macro_pront('@FormatOrientPreEstabAge',869)) ||CHR(10)||
			replace(obter_desc_expressao(642300), '@FormatacaoOrientExtPre', obter_traducao_macro_pront('@FormatacaoOrientExtPre',869)) ||CHR(10)||
			replace(obter_desc_expressao(890039), '@FormatOrientExtPreEstabAg', obter_traducao_macro_pront('@FormatOrientExtPreEstabAg',869)) ||CHR(10)||
			replace(obter_desc_expressao(642301), '@horagenda', obter_traducao_macro_pront('@horagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642303), '@respautor', obter_traducao_macro_pront('@respautor',869)) ||CHR(10)||
			replace(obter_desc_expressao(642305), '@valor', obter_traducao_macro_pront('@valor',869)) ||CHR(10)||
			replace(obter_desc_expressao(642306), '@procinterno', obter_traducao_macro_pront('@procinterno',869)) ||CHR(10)||
			replace(obter_desc_expressao(683760), '@orientacaoexameadic', obter_traducao_macro_pront('@orientacaoexameadic',869)) ||CHR(10)||				
			replace(obter_desc_expressao(788708), '@ds_estab_agenda', obter_traducao_macro_pront('@ds_estab_agenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(788710), '@ds_end_estab_agenda', obter_traducao_macro_pront('@ds_end_estab_agenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(888797), '@OrientacaoPreparoAgeintResumido', obter_traducao_macro_pront('@OrientacaoPreparoAgeintResumido',869)) ||CHR(10)||
			replace(obter_desc_expressao(888801), '@OrientacaoPreparoAgeintItem', obter_traducao_macro_pront('@OrientacaoPreparoAgeintItem',869)) ||CHR(10)||
			replace(obter_desc_expressao(930716), '@OrientAgeIntResumoDia', obter_traducao_macro_pront('@OrientAgeIntResumoDia',869)) ||CHR(10)||
			replace(obter_desc_expressao(890979), '@prontuario', obter_traducao_macro_pront('@prontuario',869)) ||CHR(10)||
			replace(obter_desc_expressao(927647), '@MaiorTempoJejumProc', obter_traducao_macro_pront('@MaiorTempoJejumProc',869)) ||CHR(10)||
			replace(obter_desc_expressao(999064), '@OrientAgenda', obter_traducao_macro_pront('@OrientAgenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(999066), '@EndAgenda', obter_traducao_macro_pront('@EndAgenda',869)) ||CHR(10)||
			coalesce(obter_traducao_macro_pront('@URL_TELEMEDICINA',869), '@URL_TELEMEDICINA') || ' = ' || obter_desc_expressao(964510) ||CHR(10)||
            replace(obter_desc_expressao(1074064), '@urlTelemedicinaExterno', obter_traducao_macro_pront('@urlTelemedicinaExterno', 869));
		end;
	else
		begin
		ds_retorno_w	:=
			--'Macros disponiveis para item, cabecalho e rodape' 
			        obter_desc_expressao(891633) ||CHR(10)||
			replace(obter_desc_expressao(349611), '@paciente', obter_traducao_macro_pront('@paciente',869)) ||CHR(10)||
			replace(obter_desc_expressao(642259), '@convenio', obter_traducao_macro_pront('@convenio',869)) ||CHR(10)||
			replace(obter_desc_expressao(642260), '@nascimento', obter_traducao_macro_pront('@nascimento',869)) ||CHR(10)||
			replace(obter_desc_expressao(642261), '@categoria', obter_traducao_macro_pront('@categoria',869)) ||CHR(10)||
			replace(obter_desc_expressao(642262), '@plano', obter_traducao_macro_pront('@plano',869)) ||CHR(10)||
			replace(obter_desc_expressao(642263), '@telefone', obter_traducao_macro_pront('@telefone',869)) ||CHR(10)||
			replace(obter_desc_expressao(642295), '@protocoloagenda', obter_traducao_macro_pront('@protocoloagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642275), '@observacao', obter_traducao_macro_pront('@observacao',869)) ||CHR(10)||
			replace(obter_desc_expressao(642281), '@checklist', obter_traducao_macro_pront('@checklist',869)) ||CHR(10)||
			replace(obter_desc_expressao(642289), '@lado', obter_traducao_macro_pront('@lado',869)) ||CHR(10)||
			replace(obter_desc_expressao(642290), '@usuario', obter_traducao_macro_pront('@usuario',869)) ||CHR(10)||
			replace(obter_desc_expressao(642291), '@senha', obter_traducao_macro_pront('@senha',869)) ||CHR(10)||
			replace(obter_desc_expressao(642306), '@procinterno', obter_traducao_macro_pront('@procinterno',869)) ||CHR(10)||
			replace(obter_desc_expressao(642308), '@dtentrega', obter_traducao_macro_pront('@dtentrega',869)) ||CHR(10)||
			replace(obter_desc_expressao(642309), '@formaentrega', obter_traducao_macro_pront('@formaentrega',869)) ||CHR(10)||
			replace(obter_desc_expressao(642310), '@maiorjejum', obter_traducao_macro_pront('@maiorjejum',869)) ||CHR(10)||
			replace(obter_desc_expressao(1064547),'@menordtchegada', obter_traducao_macro_pront('@menordtchegada',869)) ||CHR(10)||
			replace(obter_desc_expressao(788706), '@ds_end_estab_logado', obter_traducao_macro_pront('@ds_end_estab_logado',869)) ||CHR(10)||
			replace(obter_desc_expressao(788704), '@ds_estab_logado', obter_traducao_macro_pront('@ds_estab_logado',869)) ||CHR(10)||
			replace(obter_desc_expressao(642302), '@orientlab', obter_traducao_macro_pront('@orientlab',869)) ||CHR(10)||
			replace(obter_desc_expressao(642278), '@textopadraosetor', obter_traducao_macro_pront('@textopadraosetor',869)) ||CHR(10)||
			replace(obter_desc_expressao(890979), '@prontuario', obter_traducao_macro_pront('@prontuario',869)) ||CHR(10)||
            replace(obter_desc_expressao(1036698), '@inicioAgendamento', obter_traducao_macro_pront('@inicioAgendamento',869)) ||CHR(10)||
			replace(obter_desc_expressao(1068520), '@valorexamelab', obter_traducao_macro_pront('@valorexamelab',869)) ||CHR(10)||
			'' ||CHR(10)||
			--Macros disponiveis somente para o item
			replace(obter_desc_expressao(891631), '#@macro#@', obter_desc_expressao(292266)) ||CHR(10)||
			replace(obter_desc_expressao(736464), '@orientacaocomexameadic', obter_traducao_macro_pront('@orientacaocomexameadic',869)) ||CHR(10)||
			replace(obter_desc_expressao(642279), '@exameadicional', obter_traducao_macro_pront('@exameadicional',869)) ||CHR(10)||
			replace(obter_desc_expressao(642293), '@diasemana', obter_traducao_macro_pront('@diasemana',869)) ||CHR(10)||
			replace(obter_desc_expressao(642288), '@quimio', obter_traducao_macro_pront('@quimio',869)) ||CHR(10)||
			replace(obter_desc_expressao(642283), '@textopriexame', obter_traducao_macro_pront('@textopriexame',869)) ||CHR(10)||
			replace(obter_desc_expressao(642264), '@agenda', obter_traducao_macro_pront('@agenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642265), '@horario', obter_traducao_macro_pront('@horario',869)) ||CHR(10)||
			replace(obter_desc_expressao(642296), '@dtagenda', obter_traducao_macro_pront('@dtagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642301), '@horagenda', obter_traducao_macro_pront('@horagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642285), '@medreq', obter_traducao_macro_pront('@medreq',869)) ||CHR(10)||
			replace(obter_desc_expressao(642274), '@medico', obter_traducao_macro_pront('@medico',869)) ||CHR(10)||
			replace(obter_desc_expressao(642266), '@orientpac', obter_traducao_macro_pront('@orientpac',869)) ||CHR(10)||
			replace(obter_desc_expressao(642267), '@orientexame', obter_traducao_macro_pront('@orientexame',869)) ||CHR(10)||
			replace(obter_desc_expressao(642268), '@orientanestesia', obter_traducao_macro_pront('@orientanestesia',869)) ||CHR(10)||
			replace(obter_desc_expressao(642269), '@item', obter_traducao_macro_pront('@item',869)) ||CHR(10)||
			replace(obter_desc_expressao(642305), '@valor', obter_traducao_macro_pront('@valor',869)) ||CHR(10)||
			replace(obter_desc_expressao(642270), '@regra', obter_traducao_macro_pront('@regra',869)) ||CHR(10)||
			replace(obter_desc_expressao(642271), '@glosa', obter_traducao_macro_pront('@glosa',869)) ||CHR(10)||
			replace(obter_desc_expressao(642272), '@dtprevista', obter_traducao_macro_pront('@dtprevista',869)) ||CHR(10)||
			replace(obter_desc_expressao(642277), '@obsagenda', obter_traducao_macro_pront('@obsagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(642280), '@textopadraoexame', obter_traducao_macro_pront('@textopadraoexame',869)) ||CHR(10)||
			replace(obter_desc_expressao(642273), '@dtchegada', obter_traducao_macro_pront('@dtchegada',869)) ||CHR(10)||
			replace(obter_desc_expressao(642282), '@reserva', obter_traducao_macro_pront('@reserva',869)) ||CHR(10)||
			replace(obter_desc_expressao(642284), '@orientpreparo', obter_traducao_macro_pront('@orientpreparo',869)) ||CHR(10)||
			replace(obter_desc_expressao(642286), '@msgencaixe', obter_traducao_macro_pront('@msgencaixe',869)) ||CHR(10)||
			replace(obter_desc_expressao(642292), '@sala', obter_traducao_macro_pront('@sala',869)) ||CHR(10)||
			replace(obter_desc_expressao(642294), '@tipoagenda', obter_traducao_macro_pront('@tipoagenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(788708), '@ds_estab_agenda', obter_traducao_macro_pront('@ds_estab_agenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(788710), '@ds_end_estab_agenda', obter_traducao_macro_pront('@ds_end_estab_agenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(888797), '@OrientacaoPreparoAgeintResumido', obter_traducao_macro_pront('@OrientacaoPreparoAgeintResumido',869)) ||CHR(10)||
			replace(obter_desc_expressao(888801), '@OrientacaoPreparoAgeintItem', obter_traducao_macro_pront('@OrientacaoPreparoAgeintItem',869)) ||CHR(10)||
			replace(obter_desc_expressao(930716), '@OrientAgeIntResumoDia', obter_traducao_macro_pront('@OrientAgeIntResumoDia',869)) ||CHR(10)||
			replace(obter_desc_expressao(890947), '@setor_executor', obter_traducao_macro_pront('@setor_executor',869)) ||CHR(10)||
			replace(obter_desc_expressao(927647), '@MaiorTempoJejumProc', obter_traducao_macro_pront('@MaiorTempoJejumProc',869)) ||CHR(10)||
			replace(obter_desc_expressao(999064), '@OrientAgenda', obter_traducao_macro_pront('@OrientAgenda',869)) ||CHR(10)||
			replace(obter_desc_expressao(999066), '@EndAgenda', obter_traducao_macro_pront('@EndAgenda',869)) ||CHR(10)||
			    coalesce(obter_traducao_macro_pront('@URL_TELEMEDICINA',869), '@URL_TELEMEDICINA') || ' = ' || obter_desc_expressao(964510) ||CHR(10)||
            replace(obter_desc_expressao(1074064), '@urlTelemedicinaExterno', obter_traducao_macro_pront('@urlTelemedicinaExterno', 869));

		end;
	end if;

elsif (coalesce(ie_origem_p, 'AI') = 'RTP') then
	ds_retorno_w	:=	--'@titulo	= Titulo a ser exibido na regra(depende da forma como a regra esta cadastrada), possui as seguintes opcoes: '
					obter_desc_expressao(345208)||CHR(10)||						
					--'- Orientacoes referentes ao item: XYZ '
					obter_desc_expressao(345221)||CHR(10)||
					--'- Orientacoes referentes ao Grupo Ag. Integrada: XYZ '
					obter_desc_expressao(345223)||CHR(10)||
					--'- Orientacoes referentes a Especialidade: XYZ '
					obter_desc_expressao(345226)||CHR(10)||
					--'- Orientacoes referentes ao Grupo Procedimento: XYZ '
					obter_desc_expressao(345227)||CHR(10)||
					--'- Orientacoes referentes a Area Procedimento: XYZ '
					obter_desc_expressao(345228);
end if;						

RETURN	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_macro_clob (ie_origem_p text) FROM PUBLIC;

